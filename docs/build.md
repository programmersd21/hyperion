# Building the Hyperion Kernel

This document covers the full build process from source to bootable kernel.

---

## Prerequisites

### Debian / Ubuntu / Linux Mint

```bash
sudo apt update
sudo apt install -y \
  build-essential libncurses-dev bison flex libssl-dev libelf-dev \
  dwarves bc pahole git make gcc dkms xz-utils zstd cpio perl tar
```

### Fedora / RHEL / CentOS Stream

```bash
sudo dnf groupinstall "Development Tools"
sudo dnf install -y \
  gcc make bison flex elfutils-libelf-devel openssl-devel \
  ncurses-devel bc dkms git pahole zstd perl
```

### Arch Linux / Manjaro / EndeavourOS

```bash
sudo pacman -S --needed \
  base-devel xmlto kmod inetutils bc libelf pahole cpio perl \
  tar xz zstd dkms git
```

### openSUSE Tumbleweed / Leap

```bash
sudo zypper install -y -t pattern devel_basis
sudo zypper install -y ncurses-devel openssl-devel bc dkms pahole zstd
```

---

## Getting the Kernel Source

```bash
# Download Linux 6.19.6
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.19.6.tar.xz
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.19.6.tar.sign

# Verify signature (optional but recommended)
unxz linux-6.19.6.tar.xz
gpg --locate-keys torvalds@kernel.org gregkh@kernel.org
gpg --verify linux-6.19.6.tar.sign

# Extract
tar -xf linux-6.19.6.tar
cd linux-6.19.6
```

---

## Applying the Hyperion Config

```bash
# Copy config into the kernel source tree
cp /path/to/hyperion/hyperion.config .config

# Resolve any new symbols introduced since config was generated
make olddefconfig

# Optional: Review changes interactively
make menuconfig
```

---

## Applying Patches

```bash
# Apply all Hyperion patches in order
for patch in /path/to/hyperion/patches/*.patch; do
    echo "Applying: $patch"
    git apply "$patch" || patch -p1 < "$patch"
done
```

---

## Building

```bash
# Build the kernel image, modules, and DTBs
# Use all available CPU cores for maximum speed
make -j$(nproc) LOCALVERSION="-Hyperion-0.1.1" 2>&1 | tee build.log

# Build modules only
make modules -j$(nproc)
```

### Build Time Estimates (approximate)

| CPU | Cores | Time |
|-----|-------|------|
| AMD Ryzen 9 7950X | 32 | ~3 min |
| AMD Ryzen 7 5800X | 16 | ~7 min |
| Intel Core i9-13900K | 24 | ~5 min |
| Intel Core i7-12700 | 20 | ~6 min |

---

## Installing

```bash
# Install kernel modules
sudo make modules_install

# Install kernel headers (required for DKMS)
sudo bash /path/to/hyperion/scripts/install-headers.sh

# Install the kernel image
sudo make install

# Update bootloader
sudo update-grub                                          # Debian/Ubuntu/Mint
sudo grub2-mkconfig -o /boot/grub2/grub.cfg              # Fedora/RHEL
sudo grub-mkconfig -o /boot/grub/grub.cfg                 # Arch
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg     # Fedora EFI

# Reboot
sudo reboot
```

---

## Verification After Boot

```bash
uname -r
# Expected: 6.19.6-Hyperion-0.1.1

uname -v
# Expected: #1 SMP PREEMPT Linux 6.19.6-Hyperion-0.1.1 (Soumalya Das) 2026

# Verify headers symlink exists
ls -la /lib/modules/$(uname -r)/build

# Check DKMS builds
sudo dkms autoinstall
sudo dkms status
```

---

## Automated Build Script

See [scripts/build-kernel.sh](../scripts/build-kernel.sh) for a fully automated build and install script.

```bash
sudo bash scripts/build-kernel.sh --source /path/to/linux-6.19.6 --auto
```
