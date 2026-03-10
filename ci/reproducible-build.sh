#!/usr/bin/env bash
# =============================================================================
# Hyperion Kernel — Reproducible Build Script
# Author: Soumalya Das | 2026
#
# Builds the kernel with fixed timestamps and randomness seeds to produce
# bit-for-bit identical output across machines and runs.
#
# Reference: https://reproducible-builds.org/
# =============================================================================

set -euo pipefail

KERNEL_VERSION="${1:-6.19.6}"
HYPERION_VERSION="0.1.1"
SOURCE_DIR="${2:-./linux-${KERNEL_VERSION%.*}}"

# Fixed timestamp for reproducible builds (ISO 8601)
export KBUILD_BUILD_TIMESTAMP="2026-01-01 00:00:00 UTC"
export KBUILD_BUILD_USER="Soumalya Das"
export KBUILD_BUILD_HOST="hyperion-reproducible"

# Force deterministic output
export SOURCE_DATE_EPOCH="1735689600"  # 2026-01-01 00:00:00 UTC
export PYTHONDONTWRITEBYTECODE=1
export PYTHONHASHSEED=0

# Disable locale-dependent behaviour
export LC_ALL=C
export LANG=C

cd "${SOURCE_DIR}"

echo "=== Hyperion Reproducible Build ==="
echo "Kernel: ${KERNEL_VERSION}-Hyperion-${HYPERION_VERSION}"
echo "Timestamp: ${KBUILD_BUILD_TIMESTAMP}"
echo ""

make -j"$(nproc)" \
    LOCALVERSION="-Hyperion-${HYPERION_VERSION}" \
    KBUILD_BUILD_USER="${KBUILD_BUILD_USER}" \
    KBUILD_BUILD_HOST="${KBUILD_BUILD_HOST}" \
    KBUILD_BUILD_TIMESTAMP="${KBUILD_BUILD_TIMESTAMP}"

# Generate hash of the kernel image for verification
sha256sum arch/x86/boot/bzImage > "hyperion-${KERNEL_VERSION}-${HYPERION_VERSION}.sha256"
echo "SHA256: $(cat "hyperion-${KERNEL_VERSION}-${HYPERION_VERSION}.sha256")"
echo ""
echo "Reproducible build complete."
echo "Verify on another machine with: sha256sum -c hyperion-${KERNEL_VERSION}-${HYPERION_VERSION}.sha256"
