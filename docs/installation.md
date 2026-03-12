# Installation Guide

## Installing Hyperion Kernel

### From Pre-built Binary (If Available)
```bash
sudo dpkg -i linux-image-6.19.6-hyperion.deb
sudo update-grub
```

### From Source
See `build.md` for complete build instructions.

## Post-Installation

### 1. Reboot into New Kernel
```bash
sudo reboot
# Select Hyperion kernel from GRUB menu
```

### 2. Verify Installation
```bash
uname -r
# Should show: 6.19.6-hyperion-2.2.2
```

### 3. Load WiFi Driver
```bash
modprobe rtl8192eu
lsmod | grep rtl8192eu
```

### 4. Configure Network
```bash
# List WiFi networks
nmcli device wifi list

# Connect to network (NetworkManager)
nmcli device wifi connect SSID --ask

# Or use wpa_supplicant
sudo wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
```

## Uninstalling

```bash
# Remove kernel (GRUB-based systems)
sudo rm -f /boot/vmlinuz-6.19.6-hyperion*
sudo rm -f /boot/initrd.img-6.19.6-hyperion*
sudo rm -rf /lib/modules/6.19.6-hyperion*
sudo update-grub
```
