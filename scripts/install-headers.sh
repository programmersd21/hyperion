#!/usr/bin/env bash
# =============================================================================
# Hyperion Kernel — Header Installation Script
# Author: Soumalya Das
# Year: 2026
#
# Installs kernel headers to the correct locations for DKMS compatibility.
#
# Usage:
#   sudo bash install-headers.sh [SOURCE_DIR] [KERNEL_VERSION]
#
# The /lib/modules/$(uname -r)/build symlink MUST point to the headers
# directory or every DKMS module build will fail.
# =============================================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()   { echo -e "${GREEN}[HEADERS]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# --------------------------------------------------------------------------
# Arguments
# --------------------------------------------------------------------------
SOURCE_DIR="${1:-$(pwd)}"
KVER="${2:-}"

# Auto-detect version from source if not provided
if [[ -z "${KVER}" ]]; then
    if [[ -f "${SOURCE_DIR}/include/config/kernel.release" ]]; then
        KVER="$(cat "${SOURCE_DIR}/include/config/kernel.release")"
    else
        error "Cannot determine kernel version. Pass it as argument: bash install-headers.sh <source_dir> <kver>"
    fi
fi

HEADERS_DEST="/usr/src/linux-headers-${KVER}"
MODULES_DIR="/lib/modules/${KVER}"

log "Kernel version: ${KVER}"
log "Source:         ${SOURCE_DIR}"
log "Headers dest:   ${HEADERS_DEST}"
log "Modules dir:    ${MODULES_DIR}"

# --------------------------------------------------------------------------
# Validate source
# --------------------------------------------------------------------------
if [[ ! -f "${SOURCE_DIR}/Makefile" ]]; then
    error "Not a kernel source tree: ${SOURCE_DIR}"
fi

if [[ $EUID -ne 0 ]]; then
    error "This script requires root. Run: sudo bash $0 $*"
fi

# --------------------------------------------------------------------------
# Step 1: Install sanitised user-space API headers
# --------------------------------------------------------------------------
log "Step 1: Installing user-space API headers to /usr..."
make -C "${SOURCE_DIR}" headers_install INSTALL_HDR_PATH=/usr -j"$(nproc)" \
    2>&1 | grep -v "^  " || true

# --------------------------------------------------------------------------
# Step 2: Prepare kernel headers (generates autoconf.h, bounds.h etc.)
# --------------------------------------------------------------------------
log "Step 2: Running modules_prepare..."
make -C "${SOURCE_DIR}" modules_prepare -j"$(nproc)" \
    2>&1 | grep -v "^  " || true

# --------------------------------------------------------------------------
# Step 3: Copy full headers directory
# --------------------------------------------------------------------------
log "Step 3: Copying headers to ${HEADERS_DEST}..."
mkdir -p "${HEADERS_DEST}"

# Copy essential header directories and files
rsync -a --delete \
    "${SOURCE_DIR}/include/" "${HEADERS_DEST}/include/"

rsync -a --delete \
    "${SOURCE_DIR}/arch/x86/include/" "${HEADERS_DEST}/arch/x86/include/"

# Copy generated headers (critical for modules — contains autoconf.h)
if [[ -d "${SOURCE_DIR}/include/generated" ]]; then
    rsync -a "${SOURCE_DIR}/include/generated/" "${HEADERS_DEST}/include/generated/"
fi

# Copy arch-specific generated headers
if [[ -d "${SOURCE_DIR}/arch/x86/include/generated" ]]; then
    mkdir -p "${HEADERS_DEST}/arch/x86/include/generated"
    rsync -a "${SOURCE_DIR}/arch/x86/include/generated/" \
        "${HEADERS_DEST}/arch/x86/include/generated/"
fi

# Copy Makefile, Kconfig, and scripts (required for external module builds)
cp "${SOURCE_DIR}/Makefile" "${HEADERS_DEST}/Makefile"
cp "${SOURCE_DIR}/Kconfig" "${HEADERS_DEST}/Kconfig" 2>/dev/null || true

rsync -a --delete "${SOURCE_DIR}/scripts/" "${HEADERS_DEST}/scripts/"
rsync -a --delete "${SOURCE_DIR}/tools/include/" "${HEADERS_DEST}/tools/include/" 2>/dev/null || true

# Module.symvers: CRITICAL for MODVERSIONS symbol CRC matching
if [[ -f "${SOURCE_DIR}/Module.symvers" ]]; then
    cp "${SOURCE_DIR}/Module.symvers" "${HEADERS_DEST}/Module.symvers"
    log "Module.symvers: copied"
else
    warn "Module.symvers not found — build the kernel first"
fi

# System.map
if [[ -f "${SOURCE_DIR}/System.map" ]]; then
    cp "${SOURCE_DIR}/System.map" "${HEADERS_DEST}/System.map"
fi

# .config
if [[ -f "${SOURCE_DIR}/.config" ]]; then
    cp "${SOURCE_DIR}/.config" "${HEADERS_DEST}/.config"
fi

# vmlinux (required by some DKMS modules for symbol resolution)
if [[ -f "${SOURCE_DIR}/vmlinux" ]]; then
    cp "${SOURCE_DIR}/vmlinux" "${HEADERS_DEST}/vmlinux"
fi

log "Headers directory created: ${GREEN}OK${NC}"

# --------------------------------------------------------------------------
# Step 4: Create build and source symlinks
# --------------------------------------------------------------------------
log "Step 4: Creating module symlinks..."

# Ensure modules directory exists
mkdir -p "${MODULES_DIR}"

# build symlink — THE most important path for DKMS
ln -sfn "${HEADERS_DEST}" "${MODULES_DIR}/build"
log "  /lib/modules/${KVER}/build -> ${HEADERS_DEST}"

# source symlink — needed by some modules
ln -sfn "${HEADERS_DEST}" "${MODULES_DIR}/source"
log "  /lib/modules/${KVER}/source -> ${HEADERS_DEST}"

# --------------------------------------------------------------------------
# Step 5: Fix permissions
# --------------------------------------------------------------------------
log "Step 5: Fixing permissions..."
chmod -R a+rX "${HEADERS_DEST}"
find "${HEADERS_DEST}/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find "${HEADERS_DEST}/scripts" -type f ! -name "*.sh" -name "fixdep" -exec chmod +x {} \; 2>/dev/null || true

# --------------------------------------------------------------------------
# Step 6: Update module dependencies
# --------------------------------------------------------------------------
log "Step 6: Updating module dependencies..."
depmod -a "${KVER}" 2>/dev/null || warn "depmod failed — run manually: sudo depmod -a ${KVER}"

# --------------------------------------------------------------------------
# Step 7: Trigger DKMS rebuild
# --------------------------------------------------------------------------
if command -v dkms &>/dev/null; then
    log "Step 7: Triggering DKMS autoinstall..."
    dkms autoinstall -k "${KVER}" 2>&1 | grep -E "(Error|Warning|installing|built|added)" || true
else
    log "Step 7: DKMS not installed — skipping"
fi

# --------------------------------------------------------------------------
# Verification
# --------------------------------------------------------------------------
echo ""
log "========== Verification =========="
echo ""

echo -e "  Headers directory:"
ls -la "${HEADERS_DEST}/" | head -10
echo ""

echo -e "  Module symlinks:"
ls -la "${MODULES_DIR}/build" "${MODULES_DIR}/source" 2>/dev/null
echo ""

echo -e "  Module.symvers: $([ -f "${HEADERS_DEST}/Module.symvers" ] && echo "${GREEN}present${NC}" || echo "${YELLOW}MISSING${NC}")"
echo -e "  .config:        $([ -f "${HEADERS_DEST}/.config" ]        && echo "${GREEN}present${NC}" || echo "${YELLOW}MISSING${NC}")"
echo -e "  autoconf.h:     $([ -f "${HEADERS_DEST}/include/generated/autoconf.h" ] && echo "${GREEN}present${NC}" || echo "${YELLOW}MISSING${NC}")"
echo ""

log "${GREEN}Header installation complete for ${KVER}${NC}"
log "DKMS modules should now build correctly."
