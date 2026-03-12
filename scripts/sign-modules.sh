#!/usr/bin/env bash
# =============================================================================
# Hyperion Kernel — Module Signing Script (Optional — Secure Boot)
# Author: Soumalya Das
# Year: 2026
#
# Usage: sudo bash sign-modules.sh [kernel_version]
#
# Only needed if:
#   - CONFIG_MODULE_SIG=y is set in your kernel config
#   - You are using Secure Boot
#   - You want DKMS modules to be signed with your own key
# =============================================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()   { echo -e "${GREEN}[SIGN]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

KVER="${1:-$(uname -r)}"
KEY_DIR="/etc/hyperion/signing-keys"
KEY_FILE="${KEY_DIR}/hyperion-signing.pem"
CERT_FILE="${KEY_DIR}/hyperion-signing.x509"
MODULES_DIR="/lib/modules/${KVER}"

[[ $EUID -ne 0 ]] && error "Must run as root"

# --------------------------------------------------------------------------
# Generate signing key if not present
# --------------------------------------------------------------------------
if [[ ! -f "${KEY_FILE}" ]]; then
    log "Generating Hyperion module signing key..."
    mkdir -p "${KEY_DIR}"
    chmod 700 "${KEY_DIR}"

    openssl req -new -x509 -newkey rsa:2048 -keyout "${KEY_FILE}" \
        -out "${CERT_FILE}" -days 3650 -subj \
        "/CN=Hyperion Kernel Module Signing Key/O=Soumalya Das/C=IN" \
        -nodes

    chmod 600 "${KEY_FILE}"
    chmod 644 "${CERT_FILE}"
    log "Key generated: ${KEY_FILE}"
    log "Cert generated: ${CERT_FILE}"
else
    log "Using existing signing key: ${KEY_FILE}"
fi

# --------------------------------------------------------------------------
# Enroll certificate in MOK (Machine Owner Key) for Secure Boot
# --------------------------------------------------------------------------
enroll_mok() {
    if command -v mokutil &>/dev/null; then
        log "Enrolling certificate in MOK database..."
        mokutil --import "${CERT_FILE}"
        log "Reboot and approve the MOK enrollment in the UEFI/shim prompt"
    else
        warn "mokutil not found — install it to enroll the key for Secure Boot"
        warn "The key is at: ${CERT_FILE}"
        warn "Enroll it manually via your UEFI firmware or: mokutil --import ${CERT_FILE}"
    fi
}

# --------------------------------------------------------------------------
# Sign all modules for the given kernel version
# --------------------------------------------------------------------------
sign_modules() {
    log "Signing all modules for kernel: ${KVER}"

    local sign_tool="/usr/src/linux-headers-${KVER}/scripts/sign-file"
    if [[ ! -x "${sign_tool}" ]]; then
        sign_tool="$(find /usr/src/linux-headers-*/scripts/ -name sign-file 2>/dev/null | head -1)"
    fi

    if [[ -z "${sign_tool}" ]] || [[ ! -x "${sign_tool}" ]]; then
        error "sign-file tool not found. Ensure kernel headers are installed."
    fi

    local count=0
    while IFS= read -r -d '' module; do
        "${sign_tool}" sha256 "${KEY_FILE}" "${CERT_FILE}" "${module}"
        ((count++))
    done < <(find "${MODULES_DIR}" -name "*.ko" -print0)

    log "Signed ${count} modules: ${GREEN}OK${NC}"
}

# --------------------------------------------------------------------------
# Configure DKMS to auto-sign
# --------------------------------------------------------------------------
configure_dkms_signing() {
    local dkms_conf="/etc/dkms/framework.conf"
    log "Configuring DKMS auto-signing..."

    cat >> "${dkms_conf}" << EOF

# Hyperion Kernel — auto-sign modules with our key
sign_tool="/usr/src/linux-headers-\$(uname -r)/scripts/sign-file"
mok_signing_key="${KEY_FILE}"
mok_certificate="${CERT_FILE}"
EOF
    log "DKMS signing configured: ${dkms_conf}"
}

# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------
main() {
    log "Hyperion Module Signing for kernel: ${KVER}"
    sign_modules

    if [[ ! -f "/sys/firmware/efi" ]]; then
        warn "Not an EFI system — Secure Boot MOK enrollment skipped"
    else
        enroll_mok
    fi

    configure_dkms_signing
    log "Module signing complete"
}

main "$@"
