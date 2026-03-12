/* SPDX-License-Identifier: GPL-2.0 */
/*
 * RTL8192EU USB 802.11n Wi-Fi driver
 *
 * Adapted from Realtek staging driver and Mange/rtl8192eu-linux-driver
 * for in-tree integration with Linux 6.19+
 *
 * Original authors: Realtek Semiconductor Corp.
 * In-tree integration: Hyperion Kernel project
 *
 * Ref: https://github.com/Mange/rtl8192eu-linux-driver
 */

#ifndef __RTL8192EU_DRV_H__
#define __RTL8192EU_DRV_H__

#include <linux/version.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/usb.h>
#include <linux/netdevice.h>
#include <linux/wireless.h>
#include <net/cfg80211.h>
#include <net/mac80211.h>
#include <linux/skbuff.h>
#include <linux/spinlock.h>
#include <linux/workqueue.h>
#include <linux/timer.h>
#include <linux/firmware.h>
#include <linux/ieee80211.h>

/* ── Driver identity ────────────────────────────────────────────────────── */
#define RTL8192EU_MODULE_NAME     "rtl8192eu"
#define RTL8192EU_MODULE_VERSION  "1.0.0-hyperion"
#define RTL8192EU_AUTHOR          "Realtek / Hyperion Kernel Project"

/* ── USB VID/PID table entries ──────────────────────────────────────────── */
#define RTL8192EU_USB_VENDOR_ID_REALTEK    0x0bda
#define RTL8192EU_USB_PRODUCT_ID_8192EU    0x818b
#define RTL8192EU_USB_PRODUCT_ID_8192EU_2  0x0179

/* TP-Link TL-WN823N v2/v3 */
#define RTL8192EU_USB_VENDOR_ID_TPLINK     0x2357
#define RTL8192EU_USB_PRODUCT_ID_WN823N    0x6109

/* ── Hardware parameters ────────────────────────────────────────────────── */
#define RTL8192EU_MAX_TX_QUEUE         9
#define RTL8192EU_MAX_RX_URBS         64
#define RTL8192EU_MAX_TX_URBS         64
#define RTL8192EU_RX_BUFFER_SIZE    8192
#define RTL8192EU_TX_BUFFER_SIZE    8192

#define RTL8192EU_TX_HIGH_QUEUE       0
#define RTL8192EU_TX_MGMT_QUEUE       1
#define RTL8192EU_TX_VI_QUEUE         2
#define RTL8192EU_TX_VO_QUEUE         3
#define RTL8192EU_TX_BE_QUEUE         4
#define RTL8192EU_TX_BK_QUEUE         5
#define RTL8192EU_TX_BCN_QUEUE        6
#define RTL8192EU_TX_LOW_QUEUE        7

/* ── MAC80211 HW flags ──────────────────────────────────────────────────── */
#define RTL8192EU_HW_FLAGS \
	(IEEE80211_HW_SIGNAL_DBM | \
	 IEEE80211_HW_HAS_RATE_CONTROL | \
	 IEEE80211_HW_RX_INCLUDES_FCS | \
	 IEEE80211_HW_SUPPORTS_PS)

/* ── Firmware ───────────────────────────────────────────────────────────── */
#define RTL8192EU_FW_NAME    "rtlwifi/rtl8192eufw.bin"
#define RTL8192EU_FW_VERSION  0x01

/* ── Driver state ───────────────────────────────────────────────────────── */
enum rtl8192eu_state {
	RTL8192EU_STATE_STOPPED  = 0,
	RTL8192EU_STATE_STARTING = 1,
	RTL8192EU_STATE_RUNNING  = 2,
	RTL8192EU_STATE_STOPPING = 3,
};

/* ── TX URB context ─────────────────────────────────────────────────────── */
struct rtl8192eu_tx_urb {
	struct list_head    list;
	struct urb         *urb;
	struct sk_buff     *skb;
	struct rtl8192eu   *priv;
};

/* ── RX URB context ─────────────────────────────────────────────────────── */
struct rtl8192eu_rx_urb {
	struct list_head    list;
	struct urb         *urb;
	u8                 *buf;
	struct rtl8192eu   *priv;
};

/* ── Per-device private data ────────────────────────────────────────────── */
struct rtl8192eu {
	/* USB core */
	struct usb_device        *udev;
	struct usb_interface     *intf;
	struct ieee80211_hw      *hw;
	struct ieee80211_vif     *vif;

	/* State */
	enum rtl8192eu_state      state;
	spinlock_t                lock;
	struct mutex              mutex;

	/* MAC address */
	u8                        mac_addr[ETH_ALEN];

	/* Firmware */
	const struct firmware    *fw;
	bool                      fw_loaded;

	/* TX */
	struct list_head          tx_free_list;
	struct list_head          tx_pending_list;
	spinlock_t                tx_lock;
	int                       tx_urb_count;
	struct rtl8192eu_tx_urb   tx_urbs[RTL8192EU_MAX_TX_URBS];

	/* RX */
	struct list_head          rx_free_list;
	spinlock_t                rx_lock;
	struct rtl8192eu_rx_urb   rx_urbs[RTL8192EU_MAX_RX_URBS];

	/* Workqueue */
	struct workqueue_struct  *wq;
	struct work_struct        rx_work;
	struct work_struct        tx_work;

	/* Stats */
	unsigned long             rx_packets;
	unsigned long             tx_packets;
	unsigned long             rx_errors;
	unsigned long             tx_errors;

	/* Channel / rate */
	struct ieee80211_channel *channel;
	int                       band;

	/* Endpoint addresses */
	u8                        bulk_in_ep;
	u8                        bulk_out_eps[RTL8192EU_MAX_TX_QUEUE];
	int                       bulk_out_ep_count;
};

/* ── Function prototypes ────────────────────────────────────────────────── */
int  rtl8192eu_init_hw(struct rtl8192eu *priv);
void rtl8192eu_deinit_hw(struct rtl8192eu *priv);
int  rtl8192eu_load_firmware(struct rtl8192eu *priv);
void rtl8192eu_release_firmware(struct rtl8192eu *priv);
int  rtl8192eu_start_tx(struct rtl8192eu *priv);
void rtl8192eu_stop_tx(struct rtl8192eu *priv);
int  rtl8192eu_start_rx(struct rtl8192eu *priv);
void rtl8192eu_stop_rx(struct rtl8192eu *priv);

/* ── Compatibility shims (Linux 6.x API) ────────────────────────────────── */
/* dev_addr_set() was added in 5.17 -- used instead of direct dev->dev_addr */
#if LINUX_VERSION_CODE < KERNEL_VERSION(5, 17, 0)
static inline void rtl8192eu_set_mac(struct net_device *dev, const u8 *addr)
{
	memcpy(dev->dev_addr, addr, ETH_ALEN);
}
#else
#define rtl8192eu_set_mac(dev, addr) dev_addr_set(dev, addr)
#endif

#endif /* __RTL8192EU_DRV_H__ */
