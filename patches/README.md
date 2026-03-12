# Hyperion Kernel Patches

This directory contains patches for the Linux kernel.

## 0001-rtl8192eu-add-in-tree-driver.patch

Adds the complete RTL8192EU driver (523 files, 13MB of source code) as an in-tree driver.

### Application

```bash
cd linux-6.19.6
patch -p1 < ../patches/0001-rtl8192eu-add-in-tree-driver.patch
make -j$(nproc)
```

### Features
- Complete MAC80211 framework
- Full USB 2.0 support
- Power management
- 100+ device support
- Linux 5.15+ compatible
