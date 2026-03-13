#!/bin/bash
# Hyperion Kernel Builder v2.2.3
# Builds Linux 6.19.6 with the Hyperion configuration and patches.
#
# Usage:
#   bash build-kernel.sh              # auto build
#   bash build-kernel.sh --interactive  # pause for menuconfig
#   bash build-kernel.sh --source /path/to/linux-6.19.6
set -euo pipefail

KERNEL_VERSION="6.19.6"
HYPERION_VER="2.2.3"
LOCALVERSION="-Hyperion-${HYPERION_VER}"
TARBALL="linux-${KERNEL_VERSION}.tar.xz"
KERNEL_DIR="kernel"
PATCHES_DIR="$(dirname "$0")/../patches"
CONFIG="$(dirname "$0")/../hyperion.config"

INTERACTIVE=0
SOURCE_DIR=""
for arg in "$@"; do
  case "$arg" in
    --interactive) INTERACTIVE=1 ;;
    --source) SOURCE_DIR="$2"; shift ;;
    --auto) ;;
  esac
  shift 2>/dev/null || true
done

echo "[*] Hyperion Kernel Builder v${HYPERION_VER}"
echo "    Target: Linux ${KERNEL_VERSION}${LOCALVERSION}"
echo ""

# ── Source ──────────────────────────────────────────────────────
if [[ -n "$SOURCE_DIR" ]]; then
  echo "[*] Using provided source: $SOURCE_DIR"
  ln -sfn "$SOURCE_DIR" "$KERNEL_DIR"
elif [[ ! -d "$KERNEL_DIR" ]]; then
  if [[ ! -f "$TARBALL" ]]; then
    echo "[*] Downloading Linux ${KERNEL_VERSION}..."
    wget -q --show-progress \
      "https://cdn.kernel.org/pub/linux/kernel/v6.x/${TARBALL}"
  fi
  echo "[*] Extracting..."
  rm -rf "$KERNEL_DIR" && mkdir "$KERNEL_DIR"
  XZ_OPT="-T0" tar -xf "$TARBALL" -C "$KERNEL_DIR" --strip-components=1
fi

cd "$KERNEL_DIR"

# ── Patches ─────────────────────────────────────────────────────
echo "[*] Applying patches..."
shopt -s nullglob
SENTINEL=".patches-applied"
PATCHES_HASH=$(sha256sum "${PATCHES_DIR}"/*.patch 2>/dev/null | sha256sum | cut -c1-12 || echo "none")

if [[ -f "$SENTINEL" ]] && [[ "$(cat $SENTINEL)" == "$PATCHES_HASH" ]]; then
  echo "    ✓ Patches already applied (hash ${PATCHES_HASH}), skipping"
else
  for patch in "${PATCHES_DIR}"/*.patch; do
    echo "    → applying $(basename "$patch")"
    patch -p1 --fuzz=5 < "$patch"
  done
  echo "$PATCHES_HASH" > "$SENTINEL"
fi

# ── Configure ───────────────────────────────────────────────────
echo "[*] Configuring..."
cp "$CONFIG" .config
make olddefconfig LOCALVERSION="$LOCALVERSION"

if [[ "$INTERACTIVE" -eq 1 ]]; then
  echo "[*] Opening menuconfig — press Save then Exit when done"
  make menuconfig
fi

# Verify key options
echo "[*] Verifying critical config options..."
for opt in BPF_JIT BPF_JIT_ALWAYS_ON SCHED_CLASS_EXT FS_VERITY SECURITY_LANDLOCK ZRAM_MULTI_COMP STACKTRACE; do
  val=$(grep "^CONFIG_${opt}=" .config 2>/dev/null | cut -d= -f2 || echo "missing")
  printf "    CONFIG_%-35s = %s\n" "${opt}" "${val}"
done

# ── Build ────────────────────────────────────────────────────────
echo ""
echo "[*] Building with $(nproc) threads..."
make -j"$(nproc)" \
  LOCALVERSION="$LOCALVERSION" \
  KCFLAGS="-pipe" \
  bzImage modules

echo ""
echo "[✓] Build complete"
echo "    bzImage: $(ls -lh arch/x86/boot/bzImage | awk '{print $5}')"
echo "    Version: $(cat include/config/kernel.release 2>/dev/null || echo ${KERNEL_VERSION}${LOCALVERSION})"
echo ""
echo "Next steps:"
echo "  sudo make modules_install"
echo "  sudo make install"
echo "  sudo update-grub  # or grub2-mkconfig / grub-mkconfig"
