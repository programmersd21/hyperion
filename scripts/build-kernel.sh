#!/bin/bash
# Build Linux 6.19.6 with RTL8192EU driver
set -e
echo "[*] Hyperion Kernel Builder v2.2.2"
tar xzf linux-6.19.6.tar.gz 2>/dev/null || true
cd linux-6.19.6
patch -p1 < ../patches/0001-rtl8192eu-add-in-tree-driver.patch || true
[[ -f ../hyperion.config ]] && cp ../hyperion.config .config
make -j$(nproc)
echo "[✓] Kernel build complete"
