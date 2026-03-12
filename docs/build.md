# Building Hyperion Kernel

## Prerequisites

### Arch Linux
```bash
sudo pacman -S base-devel linux-firmware
```

### Debian/Ubuntu
```bash
sudo apt install build-essential linux-firmware bc kmod cpio flex bison
```

### Fedora
```bash
sudo dnf install gcc kernel-devel kernel-headers linux-firmware
```

## Build Steps

### 1. Extract Kernel Source
```bash
tar xzf linux-6.19.6.tar.gz
cd linux-6.19.6
```

### 2. Apply Hyperion Patch
```bash
patch -p1 < ../patches/0001-rtl8192eu-add-in-tree-driver.patch
```

### 3. Configure Kernel
```bash
# Use Hyperion config
cp ../hyperion.config .config

# Or customize
make menuconfig
# Enable: Device Drivers → Network device support → Wireless LAN → RTL8192EU
```

### 4. Build
```bash
make -j$(nproc)
```

### 5. Install
```bash
# As root
sudo make modules_install
sudo make install

# Update bootloader
sudo update-grub  # Debian/Ubuntu
sudo grub2-mkconfig -o /boot/grub2/grub.cfg  # Fedora
```

## Automatic Build

```bash
./scripts/build-kernel.sh
```

## Verification

```bash
# Check driver loaded
lsmod | grep rtl8192eu

# Check device
lsusb | grep -i realtek

# Check network interface
ip link show
```
