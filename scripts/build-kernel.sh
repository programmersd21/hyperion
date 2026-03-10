#!/usr/bin/env bash
# =============================================================================
# Hyperion Kernel — Automated Build & Install Script
# Author: Soumalya Das
# Year: 2026
# Version: 0.1.0
#
# Usage:
#   sudo bash build-kernel.sh [OPTIONS]
#
# Options:
#   --source <path>    Path to Linux kernel source tree (default: current dir)
#   --version <ver>    Kernel version string (default: 6.19.6)
#   --auto             Non-interactive build (no menuconfig)
#   --interactive      Open menuconfig before building
#   --no-install       Build only, don't install
#   --jobs <N>         Number of parallel jobs (default: nproc)
#   --help             Show this help message
# =============================================================================

set -euo pipefail

# --------------------------------------------------------------------------
# CONFIGURATION
# --------------------------------------------------------------------------
HYPERION_VERSION="0.1.0"
KERNEL_VERSION="${KERNEL_VERSION:-6.19.6}"
LOCALVERSION="-Hyperion-${HYPERION_VERSION}"
FULL_VERSION="${KERNEL_VERSION}${LOCALVERSION}"

# Kernel author attribution — embedded in uname -v and /proc/version
export KBUILD_BUILD_USER="Soumalya Das"
export KBUILD_BUILD_HOST="hyperion-build"
export KBUILD_BUILD_TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S %Z')"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Defaults
SOURCE_DIR="$(pwd)"
JOBS="$(nproc)"
INTERACTIVE=false
NO_INSTALL=false
CONFIG_FILE="$(dirname "$(realpath "$0")")/../hyperion.config"

# --------------------------------------------------------------------------
# HELPERS
# --------------------------------------------------------------------------
log()     { echo -e "${GREEN}[HYPERION]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }
heading() { echo -e "\n${BOLD}${CYAN}══════════════════════════════════════${NC}"; \
            echo -e "${BOLD}${CYAN}  $*${NC}"; \
            echo -e "${BOLD}${CYAN}══════════════════════════════════════${NC}"; }

banner() {
    echo -e "${BOLD}${BLUE}"
    cat << 'EOF'
 ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ██╗ ██████╗ ███╗   ██╗
 ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██║██╔═══██╗████╗  ██║
 ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝██║██║   ██║██╔██╗ ██║
 ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██║██║   ██║██║╚██╗██║
 ██║  ██║   ██║   ██║     ███████╗██║  ██║██║╚██████╔╝██║ ╚████║
 ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
EOF
    echo -e "${NC}"
    echo -e "  ${BOLD}Hyperion Kernel Build System v${HYPERION_VERSION}${NC}"
    echo -e "  Author: ${BOLD}Soumalya Das${NC} | Year: 2026"
    echo -e "  Target: ${BOLD}Linux ${FULL_VERSION}${NC}"
    echo ""
}

usage() {
    cat << EOF
Usage: sudo bash build-kernel.sh [OPTIONS]

Options:
  --source <path>    Path to Linux 6.19.6 source tree (default: current directory)
  --config <path>    Path to .config file (default: ../hyperion.config)
  --version <ver>    Kernel base version (default: 6.19.6)
  --jobs <N>         Parallel build jobs (default: all CPU cores = $(nproc))
  --auto             Non-interactive: no menuconfig, just build
  --interactive      Open menuconfig before building
  --no-install       Build only, skip installation
  --help             Show this help

Examples:
  sudo bash build-kernel.sh --source ~/linux-6.19.6 --auto
  sudo bash build-kernel.sh --source ~/linux-6.19.6 --interactive --jobs 8
  bash build-kernel.sh --source ~/linux-6.19.6 --no-install
EOF
}

# --------------------------------------------------------------------------
# ARGUMENT PARSING
# --------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --source)     SOURCE_DIR="$2"; shift 2 ;;
        --config)     CONFIG_FILE="$2"; shift 2 ;;
        --version)    KERNEL_VERSION="$2"; shift 2 ;;
        --jobs)       JOBS="$2"; shift 2 ;;
        --auto)       INTERACTIVE=false; shift ;;
        --interactive) INTERACTIVE=true; shift ;;
        --no-install) NO_INSTALL=true; shift ;;
        --help)       banner; usage; exit 0 ;;
        *)            error "Unknown option: $1. Use --help for usage." ;;
    esac
done

# --------------------------------------------------------------------------
# PRE-FLIGHT CHECKS
# --------------------------------------------------------------------------
preflight_checks() {
    heading "Pre-flight Checks"

    # Must be run as root for install steps (unless --no-install)
    if [[ "${NO_INSTALL}" == false ]] && [[ $EUID -ne 0 ]]; then
        error "This script requires root for installation. Run: sudo bash $0 $*"
    fi

    # Check source directory
    if [[ ! -f "${SOURCE_DIR}/Makefile" ]]; then
        error "Linux kernel source not found at: ${SOURCE_DIR}"
    fi
    log "Kernel source: ${SOURCE_DIR}"

    # Check config file
    if [[ ! -f "${CONFIG_FILE}" ]]; then
        error "Hyperion config not found: ${CONFIG_FILE}"
    fi
    log "Hyperion config: ${CONFIG_FILE}"

    # Check required tools
    local missing=()
    for tool in gcc make flex bison bc pahole openssl; do
        command -v "$tool" &>/dev/null || missing+=("$tool")
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing required tools: ${missing[*]}"
    fi

    log "All build dependencies: ${GREEN}OK${NC}"
    log "Build jobs: ${JOBS}"
    log "Interactive: ${INTERACTIVE}"
    log "Install after build: $([[ "$NO_INSTALL" == true ]] && echo NO || echo YES)"
}

# --------------------------------------------------------------------------
# CONFIG SETUP
# --------------------------------------------------------------------------
setup_config() {
    heading "Setting Up Hyperion Config"

    cd "${SOURCE_DIR}"

    log "Copying hyperion.config to kernel tree..."
    cp "${CONFIG_FILE}" .config

    log "Resolving new config symbols (olddefconfig)..."
    make olddefconfig LOCALVERSION="${LOCALVERSION}" \
        KBUILD_BUILD_USER="${KBUILD_BUILD_USER}" \
        KBUILD_BUILD_HOST="${KBUILD_BUILD_HOST}"

    if [[ "${INTERACTIVE}" == true ]]; then
        log "Opening menuconfig for review..."
        make menuconfig
    fi

    log "Config: ${GREEN}Ready${NC}"
}

# --------------------------------------------------------------------------
# APPLY PATCHES
# --------------------------------------------------------------------------
apply_patches() {
    heading "Applying Patches"

    local patches_dir="$(dirname "$(realpath "$0")")/../patches"

    if [[ ! -d "${patches_dir}" ]] || [[ -z "$(ls -A "${patches_dir}"/*.patch 2>/dev/null)" ]]; then
        log "No patches found — skipping"
        return 0
    fi

    cd "${SOURCE_DIR}"

    local count=0
    for patch in "${patches_dir}"/*.patch; do
        log "Applying: $(basename "$patch")"
        if ! git apply --check "${patch}" 2>/dev/null; then
            warn "git apply check failed for ${patch}, trying patch -p1..."
            patch -p1 < "${patch}" || error "Failed to apply: ${patch}"
        else
            git apply "${patch}"
        fi
        ((count++))
    done

    log "Applied ${count} patch(es): ${GREEN}OK${NC}"
}

# --------------------------------------------------------------------------
# BUILD
# --------------------------------------------------------------------------
build_kernel() {
    heading "Building Hyperion Kernel ${FULL_VERSION}"

    cd "${SOURCE_DIR}"

    local start_time
    start_time=$(date +%s)

    log "Starting kernel build with ${JOBS} jobs..."
    log "Author attribution: ${KBUILD_BUILD_USER} @ ${KBUILD_BUILD_HOST}"

    make -j"${JOBS}" \
        LOCALVERSION="${LOCALVERSION}" \
        KBUILD_BUILD_USER="${KBUILD_BUILD_USER}" \
        KBUILD_BUILD_HOST="${KBUILD_BUILD_HOST}" \
        KBUILD_BUILD_TIMESTAMP="${KBUILD_BUILD_TIMESTAMP}" \
        2>&1 | tee /tmp/hyperion-build.log

    local end_time
    end_time=$(date +%s)
    local elapsed=$(( end_time - start_time ))

    log "Kernel build complete in ${elapsed}s: ${GREEN}OK${NC}"
    log "Build log saved to: /tmp/hyperion-build.log"
}

# --------------------------------------------------------------------------
# INSTALL
# --------------------------------------------------------------------------
install_kernel() {
    heading "Installing Hyperion Kernel"

    cd "${SOURCE_DIR}"

    log "Installing kernel modules..."
    make modules_install

    log "Installing kernel image..."
    make install

    log "Installing headers (required for DKMS)..."
    bash "$(dirname "$(realpath "$0")")/install-headers.sh" \
        "${SOURCE_DIR}" "${FULL_VERSION}"

    heading "Updating Bootloader"
    if command -v update-grub &>/dev/null; then
        log "Detected: update-grub (Debian/Ubuntu/Mint)"
        update-grub
    elif command -v grub2-mkconfig &>/dev/null; then
        log "Detected: grub2-mkconfig (Fedora/RHEL)"
        if [[ -d /boot/efi ]]; then
            grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg 2>/dev/null || \
            grub2-mkconfig -o /boot/grub2/grub.cfg
        else
            grub2-mkconfig -o /boot/grub2/grub.cfg
        fi
    elif command -v grub-mkconfig &>/dev/null; then
        log "Detected: grub-mkconfig (Arch)"
        grub-mkconfig -o /boot/grub/grub.cfg
    else
        warn "No GRUB updater found. Update your bootloader manually."
    fi

    log "Installation: ${GREEN}COMPLETE${NC}"
}

# --------------------------------------------------------------------------
# DKMS REBUILD
# --------------------------------------------------------------------------
rebuild_dkms() {
    heading "Rebuilding DKMS Modules"

    if ! command -v dkms &>/dev/null; then
        warn "DKMS not installed — skipping module rebuild"
        return 0
    fi

    log "Triggering DKMS autoinstall for ${FULL_VERSION}..."
    dkms autoinstall -k "${FULL_VERSION}" 2>&1 | tee /tmp/hyperion-dkms.log || \
        warn "Some DKMS modules failed to build. Check /tmp/hyperion-dkms.log"

    dkms status
    log "DKMS rebuild: ${GREEN}Done${NC}"
}

# --------------------------------------------------------------------------
# POST-BUILD SUMMARY
# --------------------------------------------------------------------------
print_summary() {
    heading "Build Summary"

    echo -e "  ${BOLD}Kernel version:${NC}  ${FULL_VERSION}"
    echo -e "  ${BOLD}uname -r will show:${NC} ${FULL_VERSION}"
    echo -e "  ${BOLD}Author:${NC}          ${KBUILD_BUILD_USER}"
    echo -e ""

    if [[ "${NO_INSTALL}" == false ]]; then
        echo -e "  ${BOLD}Installed to:${NC}"
        echo -e "    /boot/vmlinuz-${FULL_VERSION}"
        echo -e "    /lib/modules/${FULL_VERSION}/"
        echo -e "    /usr/src/linux-headers-${FULL_VERSION}/"
        echo -e ""
        echo -e "  ${GREEN}Reboot to use Hyperion Kernel:${NC}  sudo reboot"
        echo -e ""
        echo -e "  ${BOLD}Verify after reboot:${NC}"
        echo -e "    uname -r   →  ${FULL_VERSION}"
        echo -e "    uname -v   →  #1 SMP PREEMPT ... (${KBUILD_BUILD_USER}) 2026"
    else
        echo -e "  ${YELLOW}Build only — not installed (--no-install was set)${NC}"
        echo -e "  Kernel image: ${SOURCE_DIR}/arch/x86/boot/bzImage"
    fi
    echo ""
}

# --------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------
main() {
    banner
    preflight_checks
    setup_config
    apply_patches
    build_kernel

    if [[ "${NO_INSTALL}" == false ]]; then
        install_kernel
        rebuild_dkms
    fi

    print_summary
}

main "$@"
