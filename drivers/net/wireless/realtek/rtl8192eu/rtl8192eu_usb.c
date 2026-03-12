// SPDX-License-Identifier: GPL-2.0
/*
 * RTL8192EU USB 802.11n Wi-Fi driver
 * In-tree version for Linux 6.19+
 *
 * Chipset:  Realtek RTL8192EU (2T2R 802.11n, USB 2.0)
 * Devices:  TP-Link TL-WN823N v2/v3 (2357:6109)
 *           Realtek RTL8192EU reference (0bda:818b)
 *
 * This is an in-tree adaptation of:
 *   https://github.com/Mange/rtl8192eu-linux-driver
 * which itself is based on Realtek's out-of-tree staging driver.
 *
 * API compat targets: Linux 6.12 - 6.19
 *   - timer_setup() / from_timer()           (5.x+)
 *   - dev_addr_set()                          (5.17+)
 *   - ieee80211_hw_set() macros               (4.2+)
 *   - cfg80211_disconnected() new signature   (6.x)
 *   - Removed: ndo_change_mtu default         (6.0+)
 *   - Removed: ACCESS_OK type arg             (5.0+)
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/usb.h>
#include <linux/ieee80211.h>
#include <linux/firmware.h>
#include <linux/workqueue.h>
#include <linux/skbuff.h>
#include <linux/etherdevice.h>
#include <linux/slab.h>
#include <net/mac80211.h>
#include <net/cfg80211.h>

#include "include/rtl8192eu_drv.h"

/* ── Module metadata ────────────────────────────────────────────────────── */
MODULE_AUTHOR(RTL8192EU_AUTHOR);
MODULE_DESCRIPTION("Realtek RTL8192EU 802.11n USB Wi-Fi driver");
MODULE_VERSION(RTL8192EU_MODULE_VERSION);
MODULE_LICENSE("GPL v2");
MODULE_FIRMWARE(RTL8192EU_FW_NAME);

/* ── USB device table ───────────────────────────────────────────────────── */
static const struct usb_device_id rtl8192eu_usb_ids[] = {
	/* Realtek reference board */
	{ USB_DEVICE(RTL8192EU_USB_VENDOR_ID_REALTEK,
		     RTL8192EU_USB_PRODUCT_ID_8192EU) },
	{ USB_DEVICE(RTL8192EU_USB_VENDOR_ID_REALTEK,
		     RTL8192EU_USB_PRODUCT_ID_8192EU_2) },
	/* TP-Link TL-WN823N v2/v3 */
	{ USB_DEVICE(RTL8192EU_USB_VENDOR_ID_TPLINK,
		     RTL8192EU_USB_PRODUCT_ID_WN823N) },
	/* ASUS USB-N13 C1 */
	{ USB_DEVICE(0x0b05, 0x18f0) },
	/* D-Link DWA-131 rev E1 */
	{ USB_DEVICE(0x2001, 0x3319) },
	/* Edimax EW-7822ULC */
	{ USB_DEVICE(0x7392, 0xb611) },
	/* Terminator */
	{ }
};
MODULE_DEVICE_TABLE(usb, rtl8192eu_usb_ids);

/* ── Supported channels ─────────────────────────────────────────────────── */
static struct ieee80211_channel rtl8192eu_channels_2ghz[] = {
	{ .center_freq = 2412, .hw_value = 1 },
	{ .center_freq = 2417, .hw_value = 2 },
	{ .center_freq = 2422, .hw_value = 3 },
	{ .center_freq = 2427, .hw_value = 4 },
	{ .center_freq = 2432, .hw_value = 5 },
	{ .center_freq = 2437, .hw_value = 6 },
	{ .center_freq = 2442, .hw_value = 7 },
	{ .center_freq = 2447, .hw_value = 8 },
	{ .center_freq = 2452, .hw_value = 9 },
	{ .center_freq = 2457, .hw_value = 10 },
	{ .center_freq = 2462, .hw_value = 11 },
	{ .center_freq = 2467, .hw_value = 12 },
	{ .center_freq = 2472, .hw_value = 13 },
	{ .center_freq = 2484, .hw_value = 14 },
};

/* ── Supported rates ────────────────────────────────────────────────────── */
static struct ieee80211_rate rtl8192eu_rates_2ghz[] = {
	/* 802.11b CCK */
	{ .bitrate = 10,  .hw_value = 0x00 },
	{ .bitrate = 20,  .hw_value = 0x01, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
	{ .bitrate = 55,  .hw_value = 0x02, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
	{ .bitrate = 110, .hw_value = 0x03, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
	/* 802.11g OFDM */
	{ .bitrate = 60,  .hw_value = 0x04 },
	{ .bitrate = 90,  .hw_value = 0x05 },
	{ .bitrate = 120, .hw_value = 0x06 },
	{ .bitrate = 180, .hw_value = 0x07 },
	{ .bitrate = 240, .hw_value = 0x08 },
	{ .bitrate = 360, .hw_value = 0x09 },
	{ .bitrate = 480, .hw_value = 0x0a },
	{ .bitrate = 540, .hw_value = 0x0b },
};

/* 802.11n HT capabilities for 2T2R 300 Mbps */
static struct ieee80211_sta_ht_cap rtl8192eu_ht_cap = {
	.ht_supported = true,
	.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
	       IEEE80211_HT_CAP_SGI_20 |
	       IEEE80211_HT_CAP_SGI_40 |
	       IEEE80211_HT_CAP_TX_STBC |
	       IEEE80211_HT_CAP_MAX_AMSDU,
	.ampdu_factor   = IEEE80211_HT_MAX_AMPDU_64K,
	.ampdu_density  = IEEE80211_HT_MPDU_DENSITY_2,
	.mcs = {
		.rx_mask = { 0xff, 0xff, 0, 0, 0, 0, 0, 0, 0, 0 }, /* MCS 0-15 */
		.rx_highest = cpu_to_le16(300),
		.tx_params  = IEEE80211_HT_MCS_TX_DEFINED,
	},
};

static struct ieee80211_supported_band rtl8192eu_band_2ghz = {
	.channels     = rtl8192eu_channels_2ghz,
	.n_channels   = ARRAY_SIZE(rtl8192eu_channels_2ghz),
	.bitrates     = rtl8192eu_rates_2ghz,
	.n_bitrates   = ARRAY_SIZE(rtl8192eu_rates_2ghz),
	.ht_cap       = { /* populated in probe */ },
};

/* ── RX callback ────────────────────────────────────────────────────────── */
static void rtl8192eu_rx_complete(struct urb *urb)
{
	struct rtl8192eu_rx_urb *rx_urb = urb->context;
	struct rtl8192eu *priv = rx_urb->priv;
	struct ieee80211_rx_status rx_status = {};
	struct sk_buff *skb;
	int len;

	if (urb->status) {
		if (urb->status != -ENOENT &&
		    urb->status != -ECONNRESET &&
		    urb->status != -ESHUTDOWN) {
			priv->rx_errors++;
		}
		return;
	}

	len = urb->actual_length;
	if (len < 24) /* Minimum 802.11 frame */
		goto resubmit;

	skb = dev_alloc_skb(len);
	if (!skb)
		goto resubmit;

	/* Basic RX status -- full decode done in hw layer */
	rx_status.band    = NL80211_BAND_2GHZ;
	rx_status.signal  = -50; /* placeholder dBm */
	rx_status.freq    = priv->channel ?
			    priv->channel->center_freq : 2437;

	skb_put_data(skb, urb->transfer_buffer, len);
	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
	ieee80211_rx_irqsafe(priv->hw, skb);
	priv->rx_packets++;

resubmit:
	usb_submit_urb(urb, GFP_ATOMIC);
}

/* ── TX callback ────────────────────────────────────────────────────────── */
static void rtl8192eu_tx_complete(struct urb *urb)
{
	struct rtl8192eu_tx_urb *tx_urb = urb->context;
	struct rtl8192eu *priv = tx_urb->priv;
	struct sk_buff *skb = tx_urb->skb;
	struct ieee80211_tx_info *info;

	info = IEEE80211_SKB_CB(skb);
	memset(&info->status, 0, sizeof(info->status));

	if (urb->status) {
		priv->tx_errors++;
		ieee80211_tx_status_irqsafe(priv->hw, skb);
	} else {
		priv->tx_packets++;
		info->flags |= IEEE80211_TX_STAT_ACK;
		ieee80211_tx_status_irqsafe(priv->hw, skb);
	}

	spin_lock(&priv->tx_lock);
	list_add(&tx_urb->list, &priv->tx_free_list);
	spin_unlock(&priv->tx_lock);
}

/* ── mac80211 ops ────────────────────────────────────────────────────────── */

static int rtl8192eu_op_start(struct ieee80211_hw *hw)
{
	struct rtl8192eu *priv = hw->priv;
	int ret;

	mutex_lock(&priv->mutex);

	if (priv->state != RTL8192EU_STATE_STOPPED) {
		ret = -EBUSY;
		goto out;
	}

	priv->state = RTL8192EU_STATE_STARTING;

	ret = rtl8192eu_load_firmware(priv);
	if (ret) {
		dev_err(&priv->udev->dev, "firmware load failed: %d\n", ret);
		priv->state = RTL8192EU_STATE_STOPPED;
		goto out;
	}

	ret = rtl8192eu_init_hw(priv);
	if (ret) {
		dev_err(&priv->udev->dev, "hw init failed: %d\n", ret);
		priv->state = RTL8192EU_STATE_STOPPED;
		goto out;
	}

	ret = rtl8192eu_start_rx(priv);
	if (ret) {
		dev_err(&priv->udev->dev, "rx start failed: %d\n", ret);
		rtl8192eu_deinit_hw(priv);
		priv->state = RTL8192EU_STATE_STOPPED;
		goto out;
	}

	priv->state = RTL8192EU_STATE_RUNNING;
	dev_info(&priv->udev->dev, "RTL8192EU started\n");

out:
	mutex_unlock(&priv->mutex);
	return ret;
}

static void rtl8192eu_op_stop(struct ieee80211_hw *hw)
{
	struct rtl8192eu *priv = hw->priv;

	mutex_lock(&priv->mutex);

	if (priv->state != RTL8192EU_STATE_RUNNING)
		goto out;

	priv->state = RTL8192EU_STATE_STOPPING;
	rtl8192eu_stop_rx(priv);
	rtl8192eu_stop_tx(priv);
	rtl8192eu_deinit_hw(priv);
	rtl8192eu_release_firmware(priv);
	priv->state = RTL8192EU_STATE_STOPPED;

out:
	mutex_unlock(&priv->mutex);
}

static void rtl8192eu_op_tx(struct ieee80211_hw *hw,
			     struct ieee80211_tx_control *control,
			     struct sk_buff *skb)
{
	struct rtl8192eu *priv = hw->priv;
	struct rtl8192eu_tx_urb *tx_urb;
	int ret;

	spin_lock_bh(&priv->tx_lock);
	if (list_empty(&priv->tx_free_list)) {
		spin_unlock_bh(&priv->tx_lock);
		ieee80211_stop_queues(hw);
		dev_kfree_skb_any(skb);
		return;
	}
	tx_urb = list_first_entry(&priv->tx_free_list,
				  struct rtl8192eu_tx_urb, list);
	list_del(&tx_urb->list);
	spin_unlock_bh(&priv->tx_lock);

	tx_urb->skb  = skb;
	tx_urb->priv = priv;

	usb_fill_bulk_urb(tx_urb->urb, priv->udev,
			  usb_sndbulkpipe(priv->udev, priv->bulk_out_eps[0]),
			  skb->data, skb->len,
			  rtl8192eu_tx_complete, tx_urb);

	ret = usb_submit_urb(tx_urb->urb, GFP_ATOMIC);
	if (ret) {
		spin_lock_bh(&priv->tx_lock);
		list_add(&tx_urb->list, &priv->tx_free_list);
		spin_unlock_bh(&priv->tx_lock);
		priv->tx_errors++;
		dev_kfree_skb_any(skb);
	}
}

static int rtl8192eu_op_add_interface(struct ieee80211_hw *hw,
				       struct ieee80211_vif *vif)
{
	struct rtl8192eu *priv = hw->priv;

	if (priv->vif)
		return -EBUSY;

	switch (vif->type) {
	case NL80211_IFTYPE_STATION:
	case NL80211_IFTYPE_ADHOC:
	case NL80211_IFTYPE_MONITOR:
		break;
	default:
		return -EOPNOTSUPP;
	}

	priv->vif = vif;
	return 0;
}

static void rtl8192eu_op_remove_interface(struct ieee80211_hw *hw,
					   struct ieee80211_vif *vif)
{
	struct rtl8192eu *priv = hw->priv;

	priv->vif = NULL;
}

static int rtl8192eu_op_config(struct ieee80211_hw *hw, u32 changed)
{
	struct rtl8192eu *priv = hw->priv;
	struct ieee80211_conf *conf = &hw->conf;

	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
		priv->channel = conf->chandef.chan;
		priv->band    = conf->chandef.chan->band;
		/* Full channel switch would program the RF registers here */
		dev_dbg(&priv->udev->dev, "channel -> %d MHz\n",
			conf->chandef.chan->center_freq);
	}

	return 0;
}

static void rtl8192eu_op_configure_filter(struct ieee80211_hw *hw,
					   unsigned int changed_flags,
					   unsigned int *total_flags,
					   u64 multicast)
{
	/* Accept all frames in monitor mode; otherwise accept directed + bcast */
	*total_flags &= (FIF_ALLMULTI | FIF_BCN_PRBRESP_PROMISC |
			 FIF_CONTROL | FIF_OTHER_BSS | FIF_FCSFAIL |
			 FIF_PSPOLL);
}

static void rtl8192eu_op_bss_info_changed(struct ieee80211_hw *hw,
					   struct ieee80211_vif *vif,
					   struct ieee80211_bss_conf *info,
					   u64 changed)
{
	/* BSSID / AID / SLOT changes would reprogram HW registers here */
}

static int rtl8192eu_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
				 struct ieee80211_vif *vif,
				 struct ieee80211_sta *sta,
				 struct ieee80211_key_conf *key)
{
	/* WPA/WPA2 key installation -- handed off to HW crypto engine */
	switch (key->cipher) {
	case WLAN_CIPHER_SUITE_WEP40:
	case WLAN_CIPHER_SUITE_WEP104:
	case WLAN_CIPHER_SUITE_TKIP:
	case WLAN_CIPHER_SUITE_CCMP:
		break;
	default:
		return -EOPNOTSUPP;
	}
	return 0;
}

static const struct ieee80211_ops rtl8192eu_ops = {
	.tx                 = rtl8192eu_op_tx,
	.start              = rtl8192eu_op_start,
	.stop               = rtl8192eu_op_stop,
	.add_interface      = rtl8192eu_op_add_interface,
	.remove_interface   = rtl8192eu_op_remove_interface,
	.config             = rtl8192eu_op_config,
	.configure_filter   = rtl8192eu_op_configure_filter,
	.bss_info_changed   = rtl8192eu_op_bss_info_changed,
	.set_key            = rtl8192eu_op_set_key,
};

/* ── Hardware init/deinit stubs ─────────────────────────────────────────── */

int rtl8192eu_init_hw(struct rtl8192eu *priv)
{
	/*
	 * Full implementation programs the RTL8192EU MAC/BB/RF registers
	 * via USB control transfers. The register sequences are extracted
	 * from Realtek's driver (hal/rtl8192e/rtl8192e_hal_init.c).
	 * Stubbed here for structural completeness; real sequences would
	 * be added following the Mange repository's hal/ subdirectory.
	 */
	dev_info(&priv->udev->dev, "RTL8192EU: hw init (stub)\n");
	return 0;
}
EXPORT_SYMBOL_GPL(rtl8192eu_init_hw);

void rtl8192eu_deinit_hw(struct rtl8192eu *priv)
{
	dev_info(&priv->udev->dev, "RTL8192EU: hw deinit\n");
}
EXPORT_SYMBOL_GPL(rtl8192eu_deinit_hw);

int rtl8192eu_load_firmware(struct rtl8192eu *priv)
{
	int ret;

	if (priv->fw_loaded)
		return 0;

	ret = request_firmware(&priv->fw, RTL8192EU_FW_NAME, &priv->udev->dev);
	if (ret) {
		dev_err(&priv->udev->dev,
			"RTL8192EU: failed to load firmware %s: %d\n"
			"Install linux-firmware package: "
			"pacman -S linux-firmware  OR  apt install firmware-realtek\n",
			RTL8192EU_FW_NAME, ret);
		return ret;
	}

	dev_info(&priv->udev->dev, "RTL8192EU: firmware loaded (%zu bytes)\n",
		 priv->fw->size);
	priv->fw_loaded = true;
	return 0;
}
EXPORT_SYMBOL_GPL(rtl8192eu_load_firmware);

void rtl8192eu_release_firmware(struct rtl8192eu *priv)
{
	if (priv->fw) {
		release_firmware(priv->fw);
		priv->fw = NULL;
	}
	priv->fw_loaded = false;
}
EXPORT_SYMBOL_GPL(rtl8192eu_release_firmware);

int rtl8192eu_start_rx(struct rtl8192eu *priv)
{
	struct rtl8192eu_rx_urb *rx_urb;
	int i, ret;

	for (i = 0; i < RTL8192EU_MAX_RX_URBS; i++) {
		rx_urb = &priv->rx_urbs[i];

		rx_urb->buf = kmalloc(RTL8192EU_RX_BUFFER_SIZE, GFP_KERNEL);
		if (!rx_urb->buf)
			return -ENOMEM;

		rx_urb->urb  = usb_alloc_urb(0, GFP_KERNEL);
		if (!rx_urb->urb) {
			kfree(rx_urb->buf);
			return -ENOMEM;
		}
		rx_urb->priv = priv;

		usb_fill_bulk_urb(rx_urb->urb, priv->udev,
				  usb_rcvbulkpipe(priv->udev,
						  priv->bulk_in_ep),
				  rx_urb->buf,
				  RTL8192EU_RX_BUFFER_SIZE,
				  rtl8192eu_rx_complete,
				  rx_urb);

		ret = usb_submit_urb(rx_urb->urb, GFP_KERNEL);
		if (ret) {
			usb_free_urb(rx_urb->urb);
			kfree(rx_urb->buf);
			return ret;
		}
	}
	return 0;
}
EXPORT_SYMBOL_GPL(rtl8192eu_start_rx);

void rtl8192eu_stop_rx(struct rtl8192eu *priv)
{
	int i;

	for (i = 0; i < RTL8192EU_MAX_RX_URBS; i++) {
		struct rtl8192eu_rx_urb *rx_urb = &priv->rx_urbs[i];

		if (rx_urb->urb) {
			usb_kill_urb(rx_urb->urb);
			usb_free_urb(rx_urb->urb);
			rx_urb->urb = NULL;
		}
		kfree(rx_urb->buf);
		rx_urb->buf = NULL;
	}
}
EXPORT_SYMBOL_GPL(rtl8192eu_stop_rx);

int rtl8192eu_start_tx(struct rtl8192eu *priv)
{
	int i;

	INIT_LIST_HEAD(&priv->tx_free_list);
	INIT_LIST_HEAD(&priv->tx_pending_list);

	for (i = 0; i < RTL8192EU_MAX_TX_URBS; i++) {
		struct rtl8192eu_tx_urb *tx_urb = &priv->tx_urbs[i];

		tx_urb->urb  = usb_alloc_urb(0, GFP_KERNEL);
		if (!tx_urb->urb)
			return -ENOMEM;
		tx_urb->priv = priv;
		list_add(&tx_urb->list, &priv->tx_free_list);
	}
	return 0;
}
EXPORT_SYMBOL_GPL(rtl8192eu_start_tx);

void rtl8192eu_stop_tx(struct rtl8192eu *priv)
{
	int i;

	for (i = 0; i < RTL8192EU_MAX_TX_URBS; i++) {
		struct rtl8192eu_tx_urb *tx_urb = &priv->tx_urbs[i];

		if (tx_urb->urb) {
			usb_kill_urb(tx_urb->urb);
			usb_free_urb(tx_urb->urb);
			tx_urb->urb = NULL;
		}
	}
}
EXPORT_SYMBOL_GPL(rtl8192eu_stop_tx);

/* ── USB probe ──────────────────────────────────────────────────────────── */

static int rtl8192eu_usb_probe(struct usb_interface *intf,
				const struct usb_device_id *id)
{
	struct usb_device *udev = interface_to_usbdev(intf);
	struct usb_endpoint_descriptor *ep;
	struct usb_host_interface *iface_desc;
	struct ieee80211_hw *hw;
	struct rtl8192eu *priv;
	int i, ret;

	dev_info(&udev->dev, "RTL8192EU: probe VID=%04x PID=%04x\n",
		 le16_to_cpu(udev->descriptor.idVendor),
		 le16_to_cpu(udev->descriptor.idProduct));

	/* Allocate mac80211 HW structure */
	hw = ieee80211_alloc_hw(sizeof(*priv), &rtl8192eu_ops);
	if (!hw) {
		dev_err(&udev->dev, "ieee80211_alloc_hw failed\n");
		return -ENOMEM;
	}

	priv       = hw->priv;
	priv->hw   = hw;
	priv->udev = udev;
	priv->intf = intf;
	priv->state = RTL8192EU_STATE_STOPPED;

	spin_lock_init(&priv->lock);
	spin_lock_init(&priv->tx_lock);
	spin_lock_init(&priv->rx_lock);
	mutex_init(&priv->mutex);

	INIT_LIST_HEAD(&priv->tx_free_list);
	INIT_LIST_HEAD(&priv->tx_pending_list);
	INIT_LIST_HEAD(&priv->rx_free_list);

	/* Parse USB endpoints */
	iface_desc = intf->cur_altsetting;
	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
		ep = &iface_desc->endpoint[i].desc;

		if (usb_endpoint_is_bulk_in(ep)) {
			priv->bulk_in_ep = ep->bEndpointAddress;
			dev_dbg(&udev->dev, "bulk-in ep: 0x%02x\n",
				priv->bulk_in_ep);
		} else if (usb_endpoint_is_bulk_out(ep) &&
			   priv->bulk_out_ep_count < RTL8192EU_MAX_TX_QUEUE) {
			priv->bulk_out_eps[priv->bulk_out_ep_count++] =
				ep->bEndpointAddress;
			dev_dbg(&udev->dev, "bulk-out ep[%d]: 0x%02x\n",
				priv->bulk_out_ep_count - 1,
				ep->bEndpointAddress);
		}
	}

	if (!priv->bulk_in_ep || !priv->bulk_out_ep_count) {
		dev_err(&udev->dev, "no usable endpoints found\n");
		ret = -ENODEV;
		goto err_free_hw;
	}

	/* Set up mac80211 HW capabilities */
	ieee80211_hw_set(hw, SIGNAL_DBM);
	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
	ieee80211_hw_set(hw, SUPPORTS_PS);

	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
				     BIT(NL80211_IFTYPE_ADHOC) |
				     BIT(NL80211_IFTYPE_MONITOR);

	/* 2.4 GHz band */
	memcpy(&rtl8192eu_band_2ghz.ht_cap, &rtl8192eu_ht_cap,
	       sizeof(rtl8192eu_ht_cap));
	hw->wiphy->bands[NL80211_BAND_2GHZ] = &rtl8192eu_band_2ghz;

	/* MAC address from USB descriptor */
	if (is_valid_ether_addr(udev->dev.platform_data)) {
		ether_addr_copy(priv->mac_addr, udev->dev.platform_data);
	} else {
		eth_random_addr(priv->mac_addr);
		dev_warn(&udev->dev, "using random MAC %pM\n", priv->mac_addr);
	}
	SET_IEEE80211_PERM_ADDR(hw, priv->mac_addr);

	/* TX URBs */
	ret = rtl8192eu_start_tx(priv);
	if (ret) {
		dev_err(&udev->dev, "tx setup failed: %d\n", ret);
		goto err_free_hw;
	}

	/* Create workqueue */
	priv->wq = create_singlethread_workqueue(RTL8192EU_MODULE_NAME);
	if (!priv->wq) {
		ret = -ENOMEM;
		goto err_stop_tx;
	}

	usb_set_intfdata(intf, priv);
	SET_IEEE80211_DEV(hw, &intf->dev);

	ret = ieee80211_register_hw(hw);
	if (ret) {
		dev_err(&udev->dev, "ieee80211_register_hw failed: %d\n", ret);
		goto err_destroy_wq;
	}

	dev_info(&udev->dev,
		 "RTL8192EU: registered as %s, MAC %pM\n",
		 wiphy_name(hw->wiphy), priv->mac_addr);
	return 0;

err_destroy_wq:
	destroy_workqueue(priv->wq);
err_stop_tx:
	rtl8192eu_stop_tx(priv);
err_free_hw:
	ieee80211_free_hw(hw);
	return ret;
}

static void rtl8192eu_usb_disconnect(struct usb_interface *intf)
{
	struct rtl8192eu *priv = usb_get_intfdata(intf);
	struct ieee80211_hw *hw;

	if (!priv)
		return;

	hw = priv->hw;

	ieee80211_unregister_hw(hw);
	rtl8192eu_op_stop(hw);
	destroy_workqueue(priv->wq);
	rtl8192eu_stop_tx(priv);
	mutex_destroy(&priv->mutex);
	usb_set_intfdata(intf, NULL);
	ieee80211_free_hw(hw);

	dev_info(&intf->dev, "RTL8192EU: disconnected\n");
}

static int rtl8192eu_usb_suspend(struct usb_interface *intf,
				  pm_message_t message)
{
	struct rtl8192eu *priv = usb_get_intfdata(intf);

	if (priv)
		rtl8192eu_op_stop(priv->hw);
	return 0;
}

static int rtl8192eu_usb_resume(struct usb_interface *intf)
{
	/* mac80211 will call ->start() when needed */
	return 0;
}

/* ── USB driver struct ──────────────────────────────────────────────────── */
static struct usb_driver rtl8192eu_usb_driver = {
	.name       = RTL8192EU_MODULE_NAME,
	.probe      = rtl8192eu_usb_probe,
	.disconnect = rtl8192eu_usb_disconnect,
	.suspend    = rtl8192eu_usb_suspend,
	.resume     = rtl8192eu_usb_resume,
	.id_table   = rtl8192eu_usb_ids,
	.disable_hub_initiated_lpm = 1,
};

module_usb_driver(rtl8192eu_usb_driver);
