# Hyperion Kernel Patches

This directory contains patches applied on top of the Linux baseline.

---

## Patch Format

All patches follow the standard Linux kernel patch format:

```
From: Author Name <email>
Subject: [PATCH] subsystem: description

Long description of the change.

Tested-on: hardware description
Reference: URL to upstream discussion if applicable

Signed-off-by: Soumalya Das <geniussantu1983@gmail.com>
```

## Applying Patches

Patches are applied automatically by `scripts/build-kernel.sh` in sorted order.

Manual application:
```bash
cd linux-6.19.6
patch -p1 < ../patches/0001-rtl8192eu-add-in-tree-driver.patch
```

The CI workflow applies patches with:
```bash
for patch in ../patches/*.patch; do
    patch -p1 < "$patch"
done
```

## Current Patches

| Filename | Description | Status |
|---|---|---|
| `0001-rtl8192eu-add-in-tree-driver.patch` | Add Realtek RTL8192EU in-tree driver | Active — v2.2.2 |

---

## `0001-rtl8192eu-add-in-tree-driver.patch`

**Summary:** Adds the Realtek RTL8192EU 802.11n USB Wi-Fi driver as a proper
in-tree driver under `drivers/net/wireless/realtek/rtl8192eu/`.

**Background:** The RTL8192EU chipset was previously supported by a staging driver
(`drivers/staging/rtl8192eu`) which was **removed from mainline in Linux 6.12**
due to code quality issues and lack of an active maintainer. This patch provides
a clean in-tree replacement based on the community-maintained out-of-tree driver
at https://github.com/Mange/rtl8192eu-linux-driver, ported to the Linux 6.19
mac80211/cfg80211 API.

**Files added:**
```
drivers/net/wireless/realtek/rtl8192eu/
├── Kconfig                    — Kconfig entry (CONFIG_RTL8192EU)
├── Makefile                   — Build rules
├── include/
│   └── rtl8192eu_drv.h        — Core types, API compat shims
└── rtl8192eu_usb.c            — USB probe, mac80211 ops, TX/RX
```

**Files modified:**
```
drivers/net/wireless/realtek/Kconfig   — source rtl8192eu/Kconfig
drivers/net/wireless/realtek/Makefile  — obj-$(CONFIG_RTL8192EU) += rtl8192eu/
```

**Devices covered:**

| Device | USB ID |
|---|---|
| TP-Link TL-WN823N v2 | 2357:6109 |
| TP-Link TL-WN823N v3 | 2357:6109 |
| Realtek reference board | 0bda:818b |
| Realtek reference board alt | 0bda:0179 |
| ASUS USB-N13 C1 | 0b05:18f0 |
| D-Link DWA-131 rev E1 | 2001:3319 |
| Edimax EW-7822ULC | 7392:b611 |

**API compatibility patches applied:**

| Issue | Fix |
|---|---|
| `setup_timer()` removed (5.4) | Use `timer_setup()` / `from_timer()` |
| `dev->dev_addr` direct write (5.17) | Use `dev_addr_set()` with compat shim |
| `ACCESS_OK(type,...)` signature (5.0) | Use two-arg `access_ok()` |
| `ndo_change_mtu` required (6.0) | Removed; kernel handles it |
| `do_gettimeofday` removed (5.6) | Use `ktime_get_real_ts64()` |
| `ioremap_nocache` removed (5.6) | Use `ioremap()` |
| Struct `wireless_dev` layout changes | Use cfg80211 registration path |

**Firmware requirement:**

The driver requires `/lib/firmware/rtlwifi/rtl8192eufw.bin` from the
`linux-firmware` package:
```bash
# Arch Linux
pacman -S linux-firmware

# Debian / Ubuntu
apt install firmware-realtek

# Fedora
dnf install linux-firmware
```

The Hyperion config embeds the firmware binary directly into the bzImage via:
```
CONFIG_EXTRA_FIRMWARE="rtlwifi/rtl8192eufw.bin ..."
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
```
Ensure the firmware file exists at that path at **kernel build time**.

**References:**
- https://github.com/Mange/rtl8192eu-linux-driver
- https://wiki.archlinux.org/title/Network_configuration/Wireless
- https://www.kernel.org/doc/html/latest/networking/mac80211-injection.html
- https://www.kernel.org/doc/html/latest/driver-api/80211/mac80211.html

---

## Adding Patches

1. Name your patch: `NNNN-subsystem-description.patch` (e.g. `0002-sched-tune-latency.patch`)
2. Include a proper header (see above)
3. Place it in this directory
4. Open a PR with benchmark data showing the improvement
