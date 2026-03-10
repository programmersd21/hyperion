<div align="center">

<pre style="font-size:1.1em; line-height:1.2em; color:#FFA500;">
 ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ██╗ ██████╗ ███╗   ██╗
 ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██║██╔═══██╗████╗  ██║
 ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝██║██║   ██║██╔██╗ ██║
 ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██║██║   ██║██║╚██╗██║
 ██║  ██║   ██║   ██║     ███████╗██║  ██║██║╚██████╔╝██║ ╚████║
 ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                  <strong style="color:#1e88e5;">H Y P E R I O N · v2.0.1</strong>
      <span style="color:#ff6f00;">Linux 6.19.6</span> <span style="color:#e53935;">·</span> <span style="color:#00e676;">Optimised</span> <span style="color:#e53935;">·</span> <span style="color:#ffea00;">Stable</span> <span style="color:#e53935;">·</span> <span style="color:#e040fb;">Developer-Friendly</span>
</pre>

<img src="icon/icon.png" alt="Hyperion Kernel Icon" width="120" style="margin: 10px; border-radius: 10px;">

<p style="font-size:0.95em;">
<strong>Author:</strong> Soumalya Das &nbsp;|&nbsp; <strong>License:</strong> MIT &nbsp;|&nbsp; <strong>Base:</strong> Linux 6.19.6 &nbsp;|&nbsp; <strong>Year:</strong> 2026
</p>

<p>
<a href="https://github.com/pro-grammer-SD/hyperion/actions">
<img src="https://img.shields.io/github/actions/workflow/status/pro-grammer-SD/hyperion/build.yml?style=for-the-badge&label=Kernel%20Build&color=1e88e5" alt="Build Status">
</a>
<a href="https://kernel.org">
<img src="https://img.shields.io/badge/kernel-6.19.6--Hyperion--2.0.1-blue?style=for-the-badge&color=43a047" alt="Kernel Version">
</a>
<a href="#supported-architectures">
<img src="https://img.shields.io/badge/arch-x86__64-green?style=for-the-badge&color=f9a825" alt="Architecture">
</a>
<a href="LICENSE">
<img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge&color=ffb300" alt="License: MIT">
</a>
<a href="#dkms-compatibility">
<img src="https://img.shields.io/badge/DKMS-Compatible-brightgreen?style=for-the-badge&color=8e24aa" alt="DKMS Compatible">
</a>
</p>

</div>

---

## Table of Contents

- [Overview](#overview)
- [Philosophy](#philosophy)
- [Key Features](#key-features)
- [Stability Goals](#stability-goals)
- [Performance Goals](#performance-goals)
- [Module & DKMS Compatibility](#module--dkms-compatibility)
- [Supported Architectures](#supported-architectures)
- [Quick Start](#quick-start)
- [Build Instructions](#build-instructions)
- [Installation](#installation)
- [Development Workflow](#development-workflow)
- [Troubleshooting](#troubleshooting)
- [Credits](#credits)
- [License](#license)

---

## Overview

**Hyperion Kernel** is a custom Linux 6.19.6 kernel build engineered for three primary goals: **maximum performance**, **rock-solid stability**, and **complete developer friendliness**. It ships a carefully curated configuration drawing from the best practices of CachyOS, XanMod, Nobara (Fedora Gaming), Liquorix, and upstream Linux, combined with targeted patches and a guarantee that kernel headers, DKMS modules, and external module builds just work — every single time.

Hyperion is designed for:
- Power users, gamers, and developers who demand low latency and high throughput
- Workstations running heavy workloads: video encoding, ML inference, game streaming, compilation
- Systems that rely on DKMS modules (NVIDIA, VirtualBox, ZFS, v4l2loopback, etc.)
- Developers building and testing kernel modules without fighting header or symbol versioning issues

```
uname -r  →  6.19.6-Hyperion-2.0.1
uname -v  →  #1 SMP PREEMPT Linux 6.19.6-Hyperion-2.0.1 (Soumalya Das) 2026
```

---

## Philosophy

> *"A kernel should never be the reason your work stopped."*

Hyperion is built on four principles:

1. **No Silent Deaths** — Every OOM event, lockup, and crash is logged and recoverable. No mystery reboots.
2. **Headers Always Present** — Kernel headers are built and installed as a first-class artifact, not an afterthought. DKMS modules build on the first try.
3. **Performance Without Sacrifice** — We squeeze every nanosecond of latency and every MB/s of throughput out of the hardware, but never at the cost of correctness or stability.
4. **Developer First** — Config is documented, patches are annotated, and every decision is explainable. This is a kernel you can learn from.

---

## Key Features

| Category | Feature | Details |
|---|---|---|
| **Identity** | Custom branding | `uname -r` → `6.19.6-Hyperion-2.0.1` |
| **Scheduler** | Full preemption | `CONFIG_PREEMPT=y` — lowest latency desktop |
| **Scheduler** | Autogroup | `CONFIG_SCHED_AUTOGROUP=y` — session-aware scheduling |
| **Timer** | 1000 Hz tick | `CONFIG_HZ_1000=y` — 1ms granularity |
| **Timer** | NO_HZ_FULL | Adaptive tickless reduces interrupt overhead |
| **Timer** | High-res timers | Sub-millisecond precision |
| **Memory** | MGLRU | Multi-Gen LRU — Google/Android proven page reclaim |
| **Memory** | DAMON | Intelligent memory access monitoring & reclaim |
| **Memory** | ZSWAP (ZSTD) | Compressed in-RAM swap — defeats OOM before it starts |
| **Memory** | THP (MADVISE) | Transparent huge pages opt-in — best of both worlds |
| **IO** | BFQ scheduler | Best desktop/gaming IO fairness |
| **IO** | Kyber scheduler | Lowest NVMe queue latency |
| **IO** | IO throttling | Prevents IO starvation under heavy load |
| **Network** | BBR congestion | Google's low-latency TCP congestion control |
| **Network** | FQ scheduler | Per-flow fair queuing, eliminates bufferbloat |
| **Network** | MPTCP | Multipath TCP support |
| **CPU** | AMD P-State Active | Optimal Zen3/4 boost behaviour (mode 3) |
| **CPU** | Intel P-State | Full Intel hardware-managed performance states |
| **GPU** | AMDGPU full | DC, FP, HDCP, FreeSync, ROCm/HSA |
| **GPU** | Intel i915 + Xe | Intel Arc/Tiger Lake+ full support |
| **Crypto** | AES-NI | Hardware AES — ~10x faster encrypted storage |
| **Crypto** | ChaCha20-AVX | Fast WireGuard & TLS 1.3 |
| **Modules** | IKHEADERS | In-kernel headers always available |
| **Modules** | MODVERSIONS | Symbol versioning prevents silent ABI breakage |
| **Modules** | Full DKMS path | Headers installed at correct build path |
| **Debug** | Lockup detection | Soft + hard lockup watchdog always active |
| **Debug** | PSI | Pressure stall info — see resource saturation early |
| **Security** | Hardened usercopy | Buffer overflow detection at user boundaries |
| **Security** | AppArmor | Default LSM — application sandboxing |
| **Security** | Landlock | Process-level filesystem sandboxing |

---

## Stability Goals

- **Zero silent OOM kills.** PSI + DAMON + ZSWAP catch memory pressure before the OOM killer fires. When it does fire, it logs verbosely.
- **No phantom reboots.** Soft and hard lockup detectors are always active. Hung task detection with a 120-second timeout catches stalls without false-positiving under load.
- **Correct module loading.** `CONFIG_MODVERSIONS` ensures module ABI mismatches are caught at load time, not discovered when a driver silently does nothing.
- **Thermal safety.** Power allocator thermal governor prevents cliff-edge throttle. SENSORS_CORETEMP and K10TEMP always loaded. Fan control via NCT6775 and IT87.
- **Crash visibility.** `pstore` + RAM backend logs kernel panics across reboots. You will always know why a machine died.

---

## Performance Goals

- **Scheduling latency < 1ms** for interactive tasks under mixed workload (gaming + background compile)
- **NVMe throughput** within 2% of bare `none` scheduler via Kyber with tuned queue depth
- **Gaming frame pacing** improved via PREEMPT + HIGH_RES_TIMERS + SCHED_AUTOGROUP
- **Network latency** reduced via BBR + FQ — eliminates bufferbloat on home and datacenter links
- **Memory reclaim** non-disruptive via MGLRU — proven 16–30% reduction in stutter under memory pressure (Google/ChromeOS data)
- **Crypto throughput** maximised via AES-NI + ChaCha20-AVX — full wire-speed encrypted storage and VPN

---

## Module & DKMS Compatibility

Hyperion treats module compatibility as a **first-class feature**, not an afterthought.

**What this means in practice:**
- Kernel headers are installed to `/usr/src/linux-headers-6.19.6-Hyperion-2.0.1/`
- The build symlink `/lib/modules/6.19.6-Hyperion-2.0.1/build` always points to the correct headers directory
- `CONFIG_IKHEADERS=y` makes headers available at `/sys/kernel/kheaders.tar.xz` as a runtime fallback
- `CONFIG_MODVERSIONS=y` means every exported symbol carries a CRC checksum — mismatched modules are rejected cleanly at `insmod` with a clear error, not a kernel panic
- `CONFIG_MODULE_SRCVERSION_ALL=y` embeds a srcversion hash in every module for traceability
- Module signing is **optional by default** (off) to avoid blocking DKMS workflows — can be enabled for secure-boot systems via the signing script

**DKMS modules known to work:**
- NVIDIA proprietary (550.x+)
- VirtualBox kernel modules (7.x)
- ZFS on Linux (2.x)
- v4l2loopback
- WireGuard (built-in in 5.6+, included)
- ACPI call
- tp-smapi

---

## Supported Architectures

| Architecture | Status | Notes |
|---|---|---|
| `x86_64` | ✅ **Fully supported** | Primary target, fully optimised |
| `i686` | ❌ Not supported | 32-bit dropped |
| `aarch64` | 🔜 Planned | Config work in progress |

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/pro-grammer-SD/hyperion.git
cd hyperion

# Build and install in one shot (interactive config review)
sudo bash scripts/build-kernel.sh --interactive

# Or fully automated
sudo bash scripts/build-kernel.sh --auto
```

---

## Build Instructions

### Prerequisites

```bash
# Debian/Ubuntu/Linux Mint
sudo apt install -y build-essential libncurses-dev bison flex libssl-dev \
  libelf-dev dwarves bc pahole git make gcc dkms

# Fedora/RHEL/CentOS
sudo dnf install -y gcc make bison flex elfutils-libelf-devel \
  openssl-devel ncurses-devel bc dkms git pahole

# Arch Linux / Manjaro
sudo pacman -S --needed base-devel xmlto kmod inetutils bc libelf \
  pahole cpio perl tar xz dkms git

# openSUSE
sudo zypper install -y -t pattern devel_basis
sudo zypper install -y ncurses-devel openssl-devel bc dkms pahole
```

### Build Steps

```bash
# 1. Get Linux 6.19.6 source
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.19.6.tar.xz
tar -xf linux-6.19.6.tar.xz
cd linux-6.19.6

# 2. Copy Hyperion config
cp /path/to/hyperion/hyperion.config .config

# 3. Resolve any new config symbols for your exact kernel version
make olddefconfig

# 4. Optional: review/customise
make menuconfig

# 5. Build (use all cores)
make -j$(nproc) LOCALVERSION="-Hyperion-2.0.1"

# 6. Build modules
make modules -j$(nproc)

# 7. Install modules
sudo make modules_install

# 8. Install headers (DKMS requirement)
sudo bash /path/to/hyperion/scripts/install-headers.sh

# 9. Install kernel
sudo make install

# 10. Update bootloader
sudo update-grub        # Debian/Ubuntu
sudo grub2-mkconfig -o /boot/grub2/grub.cfg  # Fedora/RHEL
sudo grub-mkconfig -o /boot/grub/grub.cfg     # Arch
```

Or use the automated script:

```bash
sudo bash scripts/build-kernel.sh --source /path/to/linux-6.19.6
```

---

## Installation

### Post-Build Verification

```bash
# Reboot into Hyperion
sudo reboot

# Verify identity
uname -r
# Expected: 6.19.6-Hyperion-2.0.1

uname -v
# Expected: #1 SMP PREEMPT Linux 6.19.6-Hyperion-2.0.1 (Soumalya Das) 2026

# Verify headers symlink
ls -la /lib/modules/$(uname -r)/build
# Should point to /usr/src/linux-headers-6.19.6-Hyperion-2.0.1

# Test DKMS
sudo dkms status

# Test module loading
sudo modprobe bfq
sudo modprobe zram
```

### Generate initramfs

Before booting the kernel, generate the initramfs:

```bash
chmod +x ./scripts/generate-initramfs.sh
./scripts/generate-initramfs.sh
```

### Installing a DKMS Module (example: v4l2loopback)

```bash
sudo apt install v4l2loopback-dkms   # or your distro equivalent
sudo dkms status
# v4l2loopback/0.12.x, 6.19.6-Hyperion-2.0.1, x86_64: installed
```

---

## Development Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                    Hyperion Dev Workflow                     │
├──────────────┬──────────────┬──────────────┬────────────────┤
│  1. Patch    │  2. Config   │  3. Build    │  4. Test       │
│              │              │              │                │
│ patches/     │ hyperion.    │ scripts/     │ CI pipeline    │
│ *.patch      │ config       │ build-       │ .github/       │
│              │              │ kernel.sh    │ workflows/     │
└──────────────┴──────────────┴──────────────┴────────────────┘
```

1. **Add a patch:** Place `*.patch` files in `patches/` — the build script applies them in sorted order
2. **Modify config:** Edit `hyperion.config` directly, add a comment explaining your change
3. **Build:** Run `scripts/build-kernel.sh`
4. **Test:** CI auto-builds on every push and PR — see `.github/workflows/build.yml`
5. **Document:** Add notes to `docs/` for anything non-obvious

See [CONTRIBUTING.md](CONTRIBUTING.md) for full contribution guidelines.

---

## Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md) for the full guide.

**Quick diagnosis:**

```bash
# Check if headers are present
ls /usr/src/linux-headers-$(uname -r)/

# Check build symlink
readlink /lib/modules/$(uname -r)/build

# Re-install headers if missing
sudo bash scripts/install-headers.sh

# Force DKMS rebuild
sudo dkms autoinstall -k $(uname -r)

# Check dmesg for module errors
dmesg | grep -E "(module|DKMS|ERROR|WARN)" | tail -30
```

---

## Credits

| Role | Name |
|---|---|
| **Linux Kernel Developer** | **Soumalya Das** |
| Base Kernel | Linus Torvalds & the Linux kernel community |
| Config inspiration | CachyOS, XanMod, Nobara Project, Liquorix |
| IO scheduler research | Paolo Valente (BFQ), Google (BBR) |
| Memory management | MGLRU: Yu Zhao (Google), DAMON: SeongJae Park |
| Thermal management | Intel Open Source Technology Center |

---

## License

Hyperion Kernel configuration, scripts, and documentation are released under the [MIT License](LICENSE).

The Linux kernel itself is licensed under **GPL-2.0-only** as required by Linus Torvalds and the kernel community. This project does not modify the kernel license.

---

<div align="center">

*Built with precision. Tuned for humans. Named after a Titan.*

**Hyperion Kernel** · Soumalya Das · 2026

</div>
