#!/usr/bin/env bash
# =============================================================================
# Hyperion Kernel — Automated Build & Install Script
# Author: Soumalya Das
# Year: 2026
# Version: 2.2.1
# =============================================================================

set -euo pipefail

# --------------------------------------------------------------------------
# DEFAULTS
# --------------------------------------------------------------------------
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
HYPERION_CONFIG="$SCRIPT_DIR/../hyperion.config"
SOURCE_DIR="$(pwd)"
JOBS="$(nproc)"
INTERACTIVE=false
NO_INSTALL=false

KBUILD_BUILD_USER="Soumalya Das"
KBUILD_BUILD_HOST="hyperion-build"
KBUILD_BUILD_TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S %Z')"

# --------------------------------------------------------------------------
# HELPER FUNCTIONS
# --------------------------------------------------------------------------
log()     { echo -e "\033[0;32m[HYPERION]\033[0m $*"; }
warn()    { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error()   { echo -e "\033[0;31m[ERROR]\033[0m $*" >&2; exit 1; }

banner() {
    echo -e "\n"
    echo " ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ██╗ ██████╗ ███╗   ██╗"
    echo " ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██║██╔═══██╗████╗  ██║"
    echo " ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝██║██║   ██║██╔██╗ ██║"
    echo " ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██║██║   ██║██║╚██╗██║"
    echo " ██║  ██║   ██║   ██║     ███████╗██║  ██║██║╚██████╔╝██║ ╚████║"
    echo " ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝"
    echo -e "\n"
    echo " Hyperion Kernel Build System v2.2.1 | Author: Soumalya Das | Year: 2026"
    echo -e "\n"
}

usage() {
    cat << EOF
Usage: sudo bash build-kernel.sh [OPTIONS]

Options:
  --source <path>    Kernel source dir (default: current)
  --config <path>    hyperion.config (default: ../hyperion.config)
  --jobs <N>         Parallel jobs (default: all cores)
  --auto             Non-interactive build
  --interactive      Open menuconfig
  --no-install       Build only, skip installation
  --help             Show this help
EOF
}

# --------------------------------------------------------------------------
# ARGUMENT PARSING
# --------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --source)      SOURCE_DIR="$2"; shift 2 ;;
        --config)      HYPERION_CONFIG="$2"; shift 2 ;;
        --jobs)        JOBS="$2"; shift 2 ;;
        --auto)        INTERACTIVE=false; shift ;;
        --interactive) INTERACTIVE=true; shift ;;
        --no-install)  NO_INSTALL=true; shift ;;
        --help)        banner; usage; exit 0 ;;
        *)             error "Unknown option: $1" ;;
    esac
done

# --------------------------------------------------------------------------
# PRE-FLIGHT CHECKS
# --------------------------------------------------------------------------
[[ $EUID -ne 0 ]] && [[ "$NO_INSTALL" == false ]] && \
    error "Root required for install steps. Run with sudo."

[[ ! -f "$SOURCE_DIR/Makefile" ]] && \
    error "Kernel source not found at: $SOURCE_DIR"

[[ ! -f "$HYPERION_CONFIG" ]] && \
    error "hyperion.config not found: $HYPERION_CONFIG"

# --------------------------------------------------------------------------
# PARSE CONFIG
# --------------------------------------------------------------------------
parse_config() {
    declare -A cfg
    while IFS='=' read -r key val; do
        [[ "$key" =~ ^# ]] && continue
        key=$(echo "$key" | xargs)
        val=$(echo "$val" | xargs | tr -d '"')
        [[ -z "$key" ]] && continue
        cfg["$key"]="$val"
    done < "$HYPERION_CONFIG"

    VERSION="${cfg[CONFIG_VERSION]:-}"
    [[ -z "$VERSION" ]] && error "CONFIG_VERSION missing or empty"

    PATCH="${cfg[CONFIG_PATCHLEVEL]:-0}"
    SUBLEVEL="${cfg[CONFIG_SUBLEVEL]:-0}"
    EXTRAVERSION="${cfg[CONFIG_EXTRAVERSION]:-}"
    LOCALVERSION="${cfg[CONFIG_LOCALVERSION]:--Hyperion-2.2.1}"

    [[ ! "$VERSION" =~ ^[0-9]+$ ]] && error "CONFIG_VERSION must be integer"
    [[ ! "$PATCH" =~ ^[0-9]+$ ]] && error "CONFIG_PATCHLEVEL must be integer"
    [[ ! "$SUBLEVEL" =~ ^[0-9]+$ ]] && error "CONFIG_SUBLEVEL must be integer"

    KERNEL_VERSION="${VERSION}.${PATCH}.${SUBLEVEL}${EXTRAVERSION}"
    FULL_VERSION="${KERNEL_VERSION}${LOCALVERSION}"

    log "Parsed config: VERSION=$VERSION PATCH=$PATCH SUBLEVEL=$SUBLEVEL EXTRAVERSION=$EXTRAVERSION LOCALVERSION=$LOCALVERSION"
    log "Computed FULL_VERSION=$FULL_VERSION"
}

# --------------------------------------------------------------------------
# BUILD FUNCTIONS
# --------------------------------------------------------------------------
setup_kernel() {
    log "Copying config and running olddefconfig..."
    cp "$HYPERION_CONFIG" "$SOURCE_DIR/.config"
    cd "$SOURCE_DIR"
    make olddefconfig LOCALVERSION="$LOCALVERSION" \
         KBUILD_BUILD_USER="$KBUILD_BUILD_USER" \
         KBUILD_BUILD_HOST="$KBUILD_BUILD_HOST"

    [[ "$INTERACTIVE" == true ]] && make menuconfig
}

apply_patches() {
    local patches_dir="$SCRIPT_DIR/../patches"
    [[ ! -d "$patches_dir" ]] && return
    for p in "$patches_dir"/*.patch; do
        [[ -f "$p" ]] || continue
        log "Applying patch: $(basename "$p")"
        git apply "$p" || patch -p1 < "$p"
    done
}

build_kernel() {
    log "Building kernel $FULL_VERSION with $JOBS jobs..."
    make -j"$JOBS" LOCALVERSION="$LOCALVERSION" \
         KBUILD_BUILD_USER="$KBUILD_BUILD_USER" \
         KBUILD_BUILD_HOST="$KBUILD_BUILD_HOST" \
         KBUILD_BUILD_TIMESTAMP="$KBUILD_BUILD_TIMESTAMP" 2>&1 | tee /tmp/hyperion-build.log
}

package_artifacts() {
    log "Packaging build artifacts..."
    tar --zstd -cf "$SOURCE_DIR/Hyperion-Kernel-${KERNEL_VERSION}.tar.zst" \
        "$SOURCE_DIR/arch/x86/boot/bzImage" \
        "$SOURCE_DIR/Module.symvers" \
        /tmp/hyperion-build.log \
        "$HYPERION_CONFIG"

    sha256sum "$SOURCE_DIR/Hyperion-Kernel-${KERNEL_VERSION}.tar.zst" > \
        "$SOURCE_DIR/Hyperion-Kernel-${KERNEL_VERSION}.sha256"
}

install_kernel() {
    [[ "$NO_INSTALL" == true ]] && return
    log "Installing kernel modules and image..."
    make modules_install
    make install
}

print_summary() {
    log "Build Summary:"
    echo "Kernel: $FULL_VERSION"
    echo "bzImage: $SOURCE_DIR/arch/x86/boot/bzImage"
    echo "Compressed archive: $SOURCE_DIR/Hyperion-Kernel-${KERNEL_VERSION}.tar.zst"
    echo "Checksum: $SOURCE_DIR/Hyperion-Kernel-${KERNEL_VERSION}.sha256"
}

# --------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------
main() {
    banner
    parse_config
    setup_kernel
    apply_patches
    build_kernel
    package_artifacts
    install_kernel
    print_summary
}

main "$@"
