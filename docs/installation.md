# Hyperion Kernel Installation Guide

---

## Post-Build Installation

After building (see [build.md](build.md)), perform the following steps.

### 1. Install Modules

```bash
cd linux-6.19.6
sudo make modules_install
```

This installs `.ko` files to `/lib/modules/6.19.6-Hyperion-2.0.1/`.

### 2. Install Headers

```bash
sudo bash /path/to/hyperion/scripts/install-headers.sh
```

This:
- Runs `make headers_install` to install sanitised user-space headers
- Copies build artifacts to `/usr/src/linux-headers-6.19.6-Hyperion-2.0.1/`
- Creates the `/lib/modules/6.19.6-Hyperion-2.0.1/build` symlink
- Triggers DKMS to rebuild all registered modules for the new kernel

### 3. Install Kernel Image

```bash
sudo make install
# Installs vmlinuz, System.map, initrd to /boot/
```

### 4. Update Bootloader

```bash
# Ubuntu / Debian / Linux Mint
sudo update-grub

# Fedora / RHEL (BIOS)
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Fedora / RHEL (UEFI)
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

# Arch Linux / Manjaro
sudo grub-mkconfig -o /boot/grub/grub.cfg

# systemd-boot users
sudo bootctl update
# Then copy vmlinuz manually or use a boot entry generator
```

---

## Installing DKMS Modules

DKMS modules will auto-build for the new kernel after headers are installed.

```bash
# Check all registered DKMS modules
sudo dkms status

# Force rebuild for current kernel
sudo dkms autoinstall -k 6.19.6-Hyperion-2.0.1

# Example: NVIDIA
sudo apt install nvidia-dkms-550   # Debian/Ubuntu
sudo dnf install akmod-nvidia       # Fedora

# Example: VirtualBox
sudo apt install virtualbox-dkms

# Example: ZFS
sudo apt install zfs-dkms

# Example: v4l2loopback
sudo apt install v4l2loopback-dkms
```

---

## Verifying the Installation

```bash
# Boot into Hyperion
sudo reboot

# After reboot:
uname -r     # Should show: 6.19.6-Hyperion-2.0.1
uname -a     # Full version string with author credit

# Verify headers are at the correct path
ls /usr/src/linux-headers-6.19.6-Hyperion-2.0.1/

# Verify build symlink
readlink /lib/modules/$(uname -r)/build
# Should show: /usr/src/linux-headers-6.19.6-Hyperion-2.0.1

# Verify DKMS modules all built
sudo dkms status
# All should show: installed

# Verify in-kernel headers accessible
ls /sys/kernel/kheaders.tar.xz
```

---

## Uninstalling Hyperion Kernel

```bash
# Remove kernel image and associated files
sudo rm -f /boot/vmlinuz-6.19.6-Hyperion-2.0.1
sudo rm -f /boot/initrd.img-6.19.6-Hyperion-2.0.1
sudo rm -f /boot/System.map-6.19.6-Hyperion-2.0.1
sudo rm -f /boot/config-6.19.6-Hyperion-2.0.1

# Remove modules
sudo rm -rf /lib/modules/6.19.6-Hyperion-2.0.1/

# Remove headers
sudo rm -rf /usr/src/linux-headers-6.19.6-Hyperion-2.0.1/

# Update bootloader
sudo update-grub   # or your distro equivalent

# Remove DKMS records for this kernel
sudo dkms remove --all -k 6.19.6-Hyperion-2.0.1
```
