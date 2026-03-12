#!/usr/bin/env bash
set -euo pipefail

echo "=== Hyperion BusyBox Initramfs Builder ==="

WORKDIR="$HOME/hyperion-rootfs"
OUTFILE="$(pwd)/initramfs.cpio.gz"

echo "[0/7] Installing required dependencies..."

sudo apt update -y
sudo apt install -y busybox-static cpio gzip

echo "[1/7] Cleaning previous build..."

rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "[2/7] Creating filesystem structure..."

mkdir -p \
bin \
proc \
sys \
dev \
etc \
tmp

chmod 1777 tmp

echo "[3/7] Installing BusyBox..."

cp /bin/busybox bin/
chmod +x bin/busybox

echo "[4/7] Creating shell symlink..."

ln -s busybox bin/sh

echo "[5/7] Creating init..."

cat << 'EOF' > init
#!/bin/sh

PATH=/bin

echo
echo "Hyperion Initramfs Booting..."
echo

# Mount essential filesystems
/bin/busybox mount -t proc proc /proc
/bin/busybox mount -t sysfs sysfs /sys
/bin/busybox mount -t devtmpfs devtmpfs /dev

echo
echo "Welcome to Hyperion Kernel!"
echo

exec /bin/sh
EOF

chmod +x init

echo "[6/7] Creating device nodes..."

sudo mknod -m 600 dev/console c 5 1 2>/dev/null || true
sudo mknod -m 666 dev/null c 1 3 2>/dev/null || true
sudo mknod -m 666 dev/tty c 5 0 2>/dev/null || true

echo "[7/7] Packing initramfs..."

find . \
| cpio -o -H newc --owner root:root 2>/dev/null \
| gzip -9 > "$OUTFILE"

echo
echo "=== Done ==="
echo
echo "Initramfs created:"
echo "$OUTFILE"
echo

echo "Copy to Windows artifacts folder:"
echo
echo "cp $OUTFILE /mnt/c/Users/(USERNAME)/path/to/wherever/you/like/it"
echo

echo "Run with QEMU:"
echo
echo "qemu-system-x86_64 ^"
echo "  -kernel bzImage ^"
echo "  -initrd initramfs.cpio.gz ^"
echo "  -append \"console=ttyS0 init=/init loglevel=3 quiet\" ^"
echo "  -nographic"
