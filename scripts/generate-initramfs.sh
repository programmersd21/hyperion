#!/bin/bash

set -e

echo "=== Hyperion BusyBox RootFS Builder ==="

WORKDIR="$HOME/hyperion-rootfs"
OUTFILE="$(pwd)/rootfs.cpio.gz"

echo "[0/7] Installing required dependencies..."

sudo apt update
sudo apt install -y \
busybox-static \
cpio \
gzip

echo "[1/7] Cleaning previous build..."

rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "[2/7] Creating filesystem structure..."

mkdir -p \
bin \
sbin \
proc \
sys \
dev \
etc \
tmp \
usr/bin \
usr/sbin \
mnt \
root

echo "[3/7] Installing BusyBox..."

cp /bin/busybox bin/

echo "[4/7] Enabling ALL BusyBox commands..."

cd bin
./busybox --install -s .
cd ..

echo "[5/7] Creating init script..."

cat << 'EOF' > init
#!/bin/busybox sh

echo
echo "Hyperion Initramfs Booting..."
echo

mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev

echo
echo "Welcome to Hyperion Kernel!"
echo

exec /bin/sh
EOF

chmod +x init

echo "[6/7] Creating device nodes..."

sudo mknod -m 600 dev/console c 5 1 || true
sudo mknod -m 666 dev/null c 1 3 || true

echo "[7/7] Packing initramfs..."

find . -print0 \
| cpio --null -ov --format=newc --owner root:root 2>/dev/null \
| gzip -9 > "$OUTFILE"

echo
echo "=== Done! ==="
echo
echo "RootFS created:"
echo "$OUTFILE"
echo
echo "Copy to Windows artifacts folder:"
echo
echo "cp $OUTFILE /mnt/c/Users/(USERNAME)/path/to/wherever/you/like/it"
