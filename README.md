<div align="center">

<pre style="font-size:1.1em; line-height:1.2em; color:#FFA500;">
 ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ██╗ ██████╗ ███╗   ██╗
 ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██║██╔═══██╗████╗  ██║
 ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝██║██║   ██║██╔██╗ ██║
 ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██║██║   ██║██║╚██╗██║
 ██║  ██║   ██║   ██║     ███████╗██║  ██║██║╚██████╔╝██║ ╚████║
 ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                  <strong style="color:#1e88e5;">H Y P E R I O N · v2.2.3</strong>
      <span style="color:#ff6f00;">Linux 6.19.6</span> <span style="color:#e53935;">·</span> <span style="color:#00e676;">Universal</span> <span style="color:#e53935;">·</span> <span style="color:#ffea00;">Stable</span> <span style="color:#e53935;">·</span> <span style="color:#e040fb;">God-Tier Daily Driver</span>
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
<img src="https://img.shields.io/badge/kernel-6.19.6--Hyperion--2.2.3-blue?style=for-the-badge&color=43a047" alt="Kernel Version">
</a>
<a href="#supported-architectures">
<img src="https://img.shields.io/badge/arch-x86__64-green?style=for-the-badge&color=f9a825" alt="Architecture">
</a>
<a href="LICENSE">
<img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge&color=ffb300" alt="License: MIT">
</a>
<a href="#module--dkms-compatibility">
<img src="https://img.shields.io/badge/DKMS-Compatible-brightgreen?style=for-the-badge&color=8e24aa" alt="DKMS Compatible">
</a>
<a href="#distro-compatibility">
<img src="https://img.shields.io/badge/Distros-Universal-red?style=for-the-badge&color=e53935" alt="Universal Distro Support">
</a>
</p>

</div>

---

## Table of Contents

- [Overview](#overview)
- [What's New in v2.2.3](#whats-new-in-v222)
- [Philosophy](#philosophy)
- [Key Features](#key-features)
- [Performance Configuration](#performance-configuration)
  - [BPF & JIT](#bpf--jit)
  - [sched-ext: Runtime BPF Schedulers](#sched-ext-runtime-bpf-schedulers)
  - [x86 Instruction Tuning](#x86-instruction-tuning)
  - [Filesystem Integrity & Unicode](#filesystem-integrity--unicode)
  - [Virtualization & Container Hardening](#virtualization--container-hardening)
  - [ZRAM Multi-Stream Compression](#zram-multi-stream-compression)
  - [Security: Landlock & IPE](#security-landlock--ipe)
  - [Debug Discipline](#debug-discipline)
- [Hardware Support](#hardware-support)
- [Security](#security)
- [Build Instructions](#build-instructions)
- [Installation](#installation)
- [Recommended Boot Parameters](#recommended-boot-parameters)
- [Troubleshooting](#troubleshooting)
- [Credits](#credits)
- [License](#license)

---

## Overview

**Hyperion Kernel** is a custom Linux 6.19.6 kernel build engineered to be the definitive daily-driver kernel for every kind of Linux user — gamers, developers, security engineers, audio producers, and tinkerers. It combines the best configuration practices from CachyOS, XanMod, Nobara, Liquorix, and upstream Linux into a single, fully integrated, zero-compromise `bzImage`.

**v2.2.3 is the "2026 Baseline" release** — a focused pass on performance correctness, system security, and runtime observability. Every improvement is expressed as a kernel configuration choice backed by upstream in-tree code. No out-of-tree driver patches. No staging code. Just the right config, fully documented.

```
uname -r  →  6.19.6-Hyperion-2.2.3
uname -v  →  #1 SMP PREEMPT Linux 6.19.6-Hyperion-2.2.3 (Soumalya Das) 2026
```

---

## What's New in v2.2.3

> *"Config-driven, not patch-driven. The kernel community maintains the code. We choose the right options."*

### Philosophy Change: Config Over Patches

Previous Hyperion releases attempted to add out-of-tree driver code via source patches. This causes cascading `make[2]: *** [drivers] Error 2` failures on every kernel version bump because a single changed API signature breaks hundreds of driver files. Drivers removed from staging were removed for reasons: code quality, lack of maintenance, or better alternatives already in-tree.

v2.2.3 takes the correct approach: **all improvements are configuration choices**, backed by upstream code that the kernel community actively maintains. The single patch in this release adds documentation only.

---

### BPF & JIT — The 2026 Networking and Scheduling Foundation

BPF is no longer just a packet filter. In 2026 it powers:
- Network policy (Cilium, Calico eBPF mode)
- Security enforcement (BPF LSM)
- CPU scheduling (sched-ext)
- System observability (bpftrace, bcc, perf)

Every one of these requires JIT compilation. Interpreted BPF is 10–100x slower and carries additional Spectre-class attack surface.

| Config | Value | Impact |
|---|---|---|
| `CONFIG_BPF_JIT` | `y` | BPF programs compile to native x86_64 — prerequisite for everything else |
| `CONFIG_BPF_JIT_ALWAYS_ON` | `y` | Removes the interpreter entirely; eliminates Spectre-BPF attack surface |
| `CONFIG_BPF_JIT_DEFAULT_ON` | `y` | JIT active from boot without sysctl — sched-ext and Cilium work out of the box |
| `CONFIG_BPF_UNPRIV_DEFAULT_OFF` | `y` | Unprivileged users cannot load BPF; closes CVE-2021-3490/2022-0185/2023-2163 class |

---

### sched-ext: Runtime BPF Schedulers

`CONFIG_SCHED_CLASS_EXT=y` enables the extensible scheduler class merged in Linux 6.12. The CPU scheduling policy can now be replaced at runtime with a BPF program — no reboot, no recompile.

```bash
# Load the CachyOS-recommended interactive scheduler
sudo scx_bpfland &

# Switch to the NUMA-aware scheduler for a compile job
sudo pkill scx_bpfland
sudo scx_rusty &

# Revert to CFS
sudo pkill scx_rusty
```

Available schedulers from the [scx project](https://github.com/sched-ext/scx):

| Scheduler | Best for |
|---|---|
| `scx_bpfland` | Desktop and gaming — interactive-first, lowest input latency |
| `scx_lavd` | Latency-critical workloads — the CachyOS default |
| `scx_rusty` | NUMA workstations and multi-socket servers |
| `scx_tickless` | HPC and ML inference — aggressive tickless |

---

### x86 Instruction Tuning

| Config | Impact |
|---|---|
| `CONFIG_X86_X2APIC=y` | Scales interrupt routing to 2^32 CPUs; reduces APIC register access latency on all platforms |
| `CONFIG_X86_CHECK_BIOS_CORRUPTION=y` | Periodic scan of BIOS reserved memory; catches firmware that silently overwrites kernel data |
| `CONFIG_X86_INTEL_USERCOPY_CHECK=y` | Selects ERMSB (enhanced REP MOVSB) for `copy_to/from_user` — ~2x throughput on Haswell+ for large syscall buffers |
| `CONFIG_X86_AMD_PSTATE_DEFAULT_MODE=3` | Active EPP: AMD hardware manages its own boost in microseconds, faster than any OS governor |

---

### Filesystem Integrity & Unicode

| Config | Purpose |
|---|---|
| `CONFIG_FS_ENCRYPTION=y` | Per-file AES encryption (fscrypt) — required by Android, ChromeOS, ext4 encrypt |
| `CONFIG_FS_VERITY=y` | Per-file Merkle-tree integrity — Android APK signing, Flatpak runtime verification |
| `CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y` | Verity digests verifiable against kernel keyring — enables IPE policy enforcement |
| `CONFIG_UNICODE=y` + `CONFIG_UNICODE_UTF8_DATA=y` | Case-insensitive directory lookups — Steam/Wine Windows game asset compatibility |

---

### Virtualization & Container Hardening

All vhost/vsock options ensure zero-copy guest networking and reliable Waydroid/container communication:

| Config | Effect |
|---|---|
| `CONFIG_VHOST_NET=y` | Zero-copy virtio-net kernel backend — eliminates one context switch per packet vs QEMU userspace |
| `CONFIG_VHOST_IOTLB=y` | IOMMU TLB for vhost devices — required for SR-IOV VF passthrough correctness |
| `CONFIG_VHOST_VSOCK=y` | Kernel-side vsock accelerator for host↔guest RPC |
| `CONFIG_VSOCKETS=y` + `CONFIG_VSOCKETS_DIAG=y` | AF_VSOCK socket family + diagnostics |
| `CONFIG_VSOCK_LOOPBACK=y` | Loopback vsock — fixes Waydroid clipboard, ADB, and full-UI |

---

### ZRAM Multi-Stream Compression

`CONFIG_ZRAM_MULTI_COMP=y` enables two compression streams per zram device. Use ZSTD as the primary (best ratio) and LZ4 as the secondary writeback stream (fastest decompression under memory pressure).

```bash
# Recommended setup for a 32 GB system
echo 16G > /sys/block/zram0/disksize
echo zstd > /sys/block/zram0/comp_algorithm       # primary: ratio
echo lz4  > /sys/block/zram0/comp_algorithm2      # secondary: speed
mkswap /dev/zram0
swapon -p 100 /dev/zram0
```

On a 32 GB system this recovers approximately 2–3 GB of additional physical RAM compared to single-stream ZSTD, with faster decompression throughput when the system is under pressure.

---

### Security: Landlock & IPE

#### Landlock

`CONFIG_SECURITY_LANDLOCK=y` — unprivileged per-process filesystem sandboxing. Unlike AppArmor/SELinux which require root policy configuration, Landlock is application-driven: any process can sandbox its own file access via syscall. Used by Flatpak, bubblewrap, and `systemd-run --property=`.

#### Integrity Policy Enforcement (IPE)

IPE is the Linux integrity enforcement framework introduced in Linux 6.9. It enforces policies that restrict code execution to files residing on dm-verity or fs-verity verified filesystems.

```
# Example IPE policy: allow execution only from boot-verified root
policy_name="hyperion-lockdown" policy_version=0.0.1
DEFAULT action=DENY
op=EXECUTE boot_verified=TRUE action=ALLOW
```

| Config | Purpose |
|---|---|
| `CONFIG_SECURITY_IPE=y` | IPE LSM core |
| `CONFIG_IPE_PROP_BOOT_VERIFIED=y` | Expose dm-verity boot-verified property to policy |
| `CONFIG_IPE_PROP_DM_VERITY=y` | dm-verity integrity property |
| `CONFIG_IPE_PROP_FS_VERITY=y` | fs-verity file integrity property |
| `CONFIG_IPE_PROP_FS_VERITY_BUILTIN_SIG=y` | Signed verity property (kernel keyring) |

---

### Debug Discipline

The following are intentionally disabled. Each one is documented so the decision is visible and reviewable:

| Config | Overhead | Decision |
|---|---|---|
| `CONFIG_DEBUG_PREEMPT` | ~3% syscall overhead | **Off** — preemption code is correct |
| `CONFIG_PROVE_LOCKING` (lockdep) | ~40% lock overhead | **Off** — use a debug kernel for lockdep |
| `CONFIG_DEBUG_ATOMIC_SLEEP` | False positives in audio RT | **Off** — breaks legitimate RT paths |
| `CONFIG_DEBUG_VM` | Per-page overhead | **Off** — unacceptable for gaming/media |
| `CONFIG_KASAN` | 2x memory overhead | **Off** — use a sanitiser build separately |

**`CONFIG_STACKTRACE=y`** is kept. Zero overhead when idle; required by `perf`, `bpftrace`, BPF `BPF_STACK_ID` maps, and kernel crash dump symbolication.

---

## Philosophy

> *"A kernel should never be the reason your work stopped."*

Hyperion is built on five principles:

1. **Config-Driven** — improvements are kernel configuration choices backed by upstream code the kernel community maintains. No staging drivers. No out-of-tree patches for functionality available in-tree.
2. **Documented Decisions** — every config option has a comment with its rationale and a source reference. This config is something you can learn from.
3. **Performance Without Sacrifice** — every nanosecond of latency extracted from the hardware, never at the cost of correctness or stability.
4. **Developer First** — KPROBES, UPROBE_EVENTS, bpftrace/bcc, LIVEPATCH, full sched-ext support. The kernel is an observable, modifiable system.
5. **Universal by Default** — one `bzImage` boots correctly on Arch, Ubuntu, Fedora, RHEL, openSUSE, Gentoo, and NixOS without configuration.

---

## Key Features

| Category | Feature | Details |
|---|---|---|
| **Identity** | Custom branding | `uname -r` → `6.19.6-Hyperion-2.2.3` |
| **Build** | Monolithic image | All in-tree drivers promoted to `=y` — zero module-load latency |
| **Build** | ZSTD compression | ~40% faster boot than GZIP on NVMe |
| **BPF** | JIT always-on | Native x86_64 BPF, no interpreter, Spectre-BPF mitigated |
| **BPF** | Unprivileged blocked | `BPF_UNPRIV_DEFAULT_OFF` — closes entire CVE class |
| **Scheduler** | sched-ext | Runtime-swappable BPF schedulers: scx_bpfland, scx_lavd, scx_rusty |
| **Scheduler** | Full preemption | `PREEMPT=y` + `PREEMPT_DYNAMIC=y` + `PREEMPT_LAZY=y` |
| **Scheduler** | Sub-ms ticks | `SCHED_HRTICK=y` — hrtimer-resolution preemption |
| **Timer** | 1000 Hz | `CONFIG_HZ_1000=y` — 1 ms scheduler granularity |
| **Memory** | MGLRU + MMU walk | Accurate cold-page detection, fewer false evictions |
| **Memory** | ZRAM multi-comp | Dual ZSTD/LZ4 stream, `CONFIG_ZRAM_MULTI_COMP=y` |
| **Memory** | ZSWAP ZSTD | Compressed in-RAM swap — defeats OOM before it starts |
| **IO** | BFQ scheduler | Best desktop/gaming IO fairness (default) |
| **IO** | io_uring | Built-in — zero module-load delay |
| **Network** | BBR default | Google's low-latency TCP congestion control |
| **Network** | CAKE qdisc | Best-in-class bufferbloat elimination |
| **Network** | WireGuard | Built-in modern VPN — ~10 Gbps with ChaCha20-NI |
| **Network** | BPF sockmap | Zero-copy socket redirection for Cilium/Envoy |
| **Filesystem** | FS_VERITY | Per-file Merkle-tree integrity |
| **Filesystem** | FS_ENCRYPTION | Per-file fscrypt AES encryption |
| **Filesystem** | Unicode | Case-insensitive fs for Steam/Wine compatibility |
| **CPU** | AMD P-State Active | Mode 3 EPP — best Zen3/4 boost |
| **CPU** | Intel P-State + HWP | Hardware-managed boost |
| **CPU** | X86_INTEL_USERCOPY_CHECK | ERMSB ~2x faster user↔kernel copies |
| **Security** | IPE | Boot-verified integrity policy enforcement |
| **Security** | Landlock | Unprivileged per-process sandboxing |
| **Security** | AppArmor (default) | Arch, Ubuntu, Debian |
| **Security** | SELinux | Fedora, RHEL, CentOS |
| **Security** | BPF LSM | eBPF-based MAC policies |
| **Dev** | KPROBES + UPROBES | bpftrace/bcc without configuration |
| **Dev** | LIVEPATCH | Zero-downtime CVE patching |
| **Dev** | sched-ext | BPF scheduler development environment |
| **Virt** | VHOST_NET | Zero-copy virtio-net kernel backend |
| **Virt** | VSOCK_LOOPBACK | Waydroid clipboard/ADB fixed |
| **Virt** | KVM full | Intel VT-x + AMD-V, SEV, SEV-SNP, TDX |
| **USB** | Autosuspend off | `USB_AUTOSUSPEND_DELAY=-1` — no device ever sleeps |
| **USB** | 1 kHz polling | `usbhid.mousepoll/kbpoll/jspoll=1` |
| **Audio** | SOF + HDA + AMD | Ice Lake through Meteor Lake, AMD ACP, RT5682, CS35L41 |
| **Wi-Fi** | Universal | ATH9K/10K/11K/12K, RTW88/89, MT7921/7925, IWLWIFI |
| **Modules** | IKHEADERS | In-kernel headers always available |
| **Modules** | MODVERSIONS | ABI mismatch caught at load, not panic |

---

## Performance Configuration

### BPF & JIT

See [What's New — BPF & JIT](#bpf--jit--the-2026-networking-and-scheduling-foundation) above.

Verify at runtime:
```bash
cat /proc/sys/net/core/bpf_jit_enable
# Expected: 1

# Verify unprivileged BPF is blocked
cat /proc/sys/kernel/unprivileged_bpf_disabled
# Expected: 2 (fully disabled)
```

### sched-ext: Runtime BPF Schedulers

Install the scx tools:
```bash
# Arch
yay -S scx-scheds

# From source
git clone https://github.com/sched-ext/scx
cd scx && cargo build --release
```

Load at runtime:
```bash
sudo scx_bpfland          # gaming / interactive
sudo scx_lavd             # CachyOS-recommended
sudo scx_rusty            # NUMA workstation
```

Verify the scheduler is active:
```bash
cat /sys/kernel/sched_ext/state
# Expected: enabled
cat /sys/kernel/sched_ext/ops_name
# Expected: bpfland (or whichever is loaded)
```

### Recommended Boot Parameters

#### AMD (Zen3/4 Desktop)

```
quiet splash
preempt=full threadirqs
usbcore.autosuspend=-1 usbcore.use_persist=1
usbhid.mousepoll=1 usbhid.kbpoll=1 usbhid.jspoll=1
amd_pstate=active amd_iommu=pt
transparent_hugepage=madvise hugepagesz=2M hugepages=512
nohz_full=1-N rcu_nocbs=1-N skew_tick=1 nosoftlockup
lsm=landlock,lockdown,yama,integrity,apparmor,bpf
```

#### Intel (12th/13th/14th gen Desktop)

```
quiet splash
preempt=full threadirqs
usbcore.autosuspend=-1 usbcore.use_persist=1
usbhid.mousepoll=1 usbhid.kbpoll=1 usbhid.jspoll=1
intel_pstate=active
transparent_hugepage=madvise hugepagesz=2M hugepages=512
nohz_full=1-N rcu_nocbs=1-N skew_tick=1 nosoftlockup
lsm=landlock,lockdown,yama,integrity,apparmor,bpf
```

Replace `N` with your last CPU index (`nproc --all` minus 1).

Note: `lsm=` now includes `integrity` (required for IMA/IPE) and places `landlock` first.

---

## Hardware Support

### Wi-Fi — Universal Chipset Coverage

| Vendor | Driver | Standards |
|---|---|---|
| Qualcomm/Atheros | `ATH9K` | 802.11n |
| Qualcomm/Atheros | `ATH10K` | 802.11ac |
| Qualcomm/Atheros | `ATH11K` | Wi-Fi 6 |
| Qualcomm/Atheros | `ATH12K` | Wi-Fi 7 |
| Realtek | `RTW88` | 802.11ac |
| Realtek | `RTW89` | Wi-Fi 6/6E |
| Intel | `IWLWIFI` | 802.11ac/ax |
| MediaTek | `MT7921` | Wi-Fi 6 |
| MediaTek | `MT7925` | Wi-Fi 7 |
| Broadcom | `BRCMFMAC` | 802.11ac |

All drivers are built-in (`=y`). No module loading required at boot.

### GPU & Display

| Driver | Hardware |
|---|---|
| `DRM_AMDGPU` | AMD GCN1 through RDNA3 — FreeSync, ROCm/HSA |
| `DRM_I915` | Intel Gen4 through Xe (Arc) |
| `DRM_XE` | Intel Arc/Battlemage |
| `DRM_NOUVEAU` | NVIDIA Turing/Ampere/Lovelace display |
| `DRM_VIRTIO_GPU` | QEMU/KVM guests |

### Audio

| Platform | Coverage |
|---|---|
| Intel SOF | Ice Lake through Meteor Lake (10th–14th gen) |
| AMD ACP | Ryzen 4000/5000/6000/7000 laptops |
| RT5682/CS35L41 | Virtually every modern laptop codec |
| USB audio | `SND_USB_AUDIO=y` with `implicit_fb=1` stability fix |

### Storage

NVMe (PCIe), NVMe-oF TCP/RDMA/FC, SATA AHCI, SCSI multi-queue, UFS — all built-in. Filesystems: ext4, XFS, Btrfs, F2FS, NTFS3, exFAT, squashfs, EROFS, overlay, NFS v4.x, CIFS/SMB.

---

## Security

Three LSMs compiled in simultaneously; active LSM selected via `security=` cmdline:

| LSM | Default for | Activation |
|---|---|---|
| **AppArmor** | Arch, Ubuntu, Debian | Default |
| **SELinux** | Fedora, RHEL, Rocky | `security=selinux` |
| **TOMOYO** | openSUSE | `security=tomoyo` |
| **Landlock** | All | Per-process via syscall |
| **BPF LSM** | All | `lsm=bpf,...` cmdline |
| **IPE** | All | Policy loaded via securityfs |

Additional hardening active by default:

| Feature | Effect |
|---|---|
| `HARDENED_USERCOPY=y` | Buffer overflow detection at user/kernel boundaries |
| `RANDOMIZE_KSTACK_OFFSET_DEFAULT=y` | Per-syscall kernel stack randomisation |
| `INIT_STACK_ALL_ZERO=y` | Zero-initialise all stack variables |
| `FORTIFY_SOURCE=y` | GCC compile-time buffer length checks |
| `STACKPROTECTOR_STRONG=y` | Stack canary on all functions with local arrays |
| `PAGE_TABLE_ISOLATION=y` + `RETPOLINE=y` | Spectre/Meltdown mitigations |
| `BPF_UNPRIV_DEFAULT_OFF=y` | Closes entire unprivileged-BPF CVE class |
| `SECURITY_IPE=y` | Boot-verified integrity policy enforcement |

---

## Build Instructions

See [docs/build.md](docs/build.md) for full instructions.

Quick start:
```bash
# Get kernel source
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.19.6.tar.xz
tar -xf linux-6.19.6.tar.xz && cd linux-6.19.6

# Apply patches and config
for p in ../patches/*.patch; do patch -p1 --fuzz=5 < "$p"; done
cp ../hyperion.config .config
make olddefconfig LOCALVERSION="-Hyperion-2.2.3"

# Build
make -j$(nproc) LOCALVERSION="-Hyperion-2.2.3" bzImage modules
```

---

## Installation

```bash
sudo make modules_install
sudo make install
sudo update-grub   # or grub2-mkconfig / grub-mkconfig per your distro
```

Generate initramfs:
```bash
# Arch (mkinitcpio)
sudo mkinitcpio -k 6.19.6-Hyperion-2.2.3 -g /boot/initramfs-hyperion-2.2.3.img

# Fedora/RHEL (dracut)
sudo dracut --force /boot/initramfs-6.19.6-Hyperion-2.2.3.img 6.19.6-Hyperion-2.2.3

# Debian/Ubuntu (update-initramfs)
sudo update-initramfs -c -k 6.19.6-Hyperion-2.2.3
```

Post-install verification:
```bash
uname -r
# Expected: 6.19.6-Hyperion-2.2.3

cat /proc/sys/net/core/bpf_jit_enable
# Expected: 1

cat /sys/module/usbcore/parameters/autosuspend
# Expected: -1

zcat /proc/config.gz | grep -E "^CONFIG_(SCHED_CLASS_EXT|SECURITY_IPE|ZRAM_MULTI_COMP|FS_VERITY)="
# All should be =y
```

---

## Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md) for the full guide.

**sched-ext not loading:**
```bash
# Check kernel support
zcat /proc/config.gz | grep SCHED_CLASS_EXT
# Expected: CONFIG_SCHED_CLASS_EXT=y

# Check scx tools are installed
which scx_bpfland || yay -S scx-scheds

# Check BPF JIT is on
cat /proc/sys/net/core/bpf_jit_enable
# Expected: 1
```

**IPE policy not applying:**
```bash
# Check IPE is active
ls /sys/kernel/security/ipe/
# If empty, add "integrity" to lsm= cmdline parameter

# Check FS verity is supported on your filesystem
tune2fs -l /dev/sdX | grep -i verity
```

**ZRAM multi-comp not available:**
```bash
zcat /proc/config.gz | grep ZRAM_MULTI_COMP
# Expected: CONFIG_ZRAM_MULTI_COMP=y

# Check available algorithms
cat /sys/block/zram0/comp_algorithm
```

**No Wi-Fi:**
```bash
lspci -k | grep -A3 -i "wireless\|network"
dmesg | grep -i "firmware\|ath\|iwl\|rtw\|mt76"
# Qualcomm/Realtek/Intel Wi-Fi requires firmware blobs from linux-firmware
sudo pacman -S linux-firmware   # Arch
sudo apt install firmware-linux  # Debian
```

---

## Development Workflow

```
patches/*.patch  →  patch -p1  →  hyperion.config  →  make olddefconfig  →  bzImage
```

1. **Config changes:** edit `hyperion.config` directly. Every option needs a comment with rationale and source.
2. **Source patches:** add `NNNN-description.patch` to `patches/` — documentation patches preferred; avoid driver code.
3. **Build:** `bash scripts/build-kernel.sh`
4. **CI:** auto-builds on every push via `.github/workflows/build.yml`

---

## Credits

| Role | Name |
|---|---|
| **Linux Kernel Developer** | **Soumalya Das** |
| Base Kernel | Linus Torvalds & the Linux kernel community |
| Config inspiration | CachyOS, XanMod, Nobara, Liquorix, Arch, Fedora, Ubuntu |
| sched-ext / BPF schedulers | sched-ext/scx project, CachyOS team |
| BPF/JIT | Alexei Starovoitov, Daniel Borkmann, Andrii Nakryiko |
| sched-ext framework | Tejun Heo, David Vernet |
| IPE framework | Fan Wu, Deven Bowers (Microsoft) |
| Landlock | Mickaël Salaün |
| ZRAM multi-comp | Sergey Senozhatsky |
| FS Verity | Eric Biggers (Google) |
| AMD P-State | AMD Open Source driver team |
| Intel P-State | Intel Open Source Technology Center |
| BPF sockmap | John Fastabend, Daniel Borkmann |
| Memory management | MGLRU: Yu Zhao (Google); DAMON: SeongJae Park (Amazon) |
| PREEMPT_LAZY | Peter Zijlstra, Thomas Gleixner |
| USB autosuspend analysis | Sarah Sharp, Alan Stern |
| Live kernel patching | Josh Poimboeuf (Red Hat) |
| Security hardening | Kees Cook |
| Performance research | Phoronix, LKML, r/linux_gaming, CachyOS/XanMod teams |

---

## License

Hyperion Kernel configuration, scripts, and documentation are released under the [MIT License](LICENSE).

The Linux kernel itself is licensed under **GPL-2.0-only**.

---

<div align="center">

*Built with precision. Tuned for humans. Named after a Titan.*

**Hyperion Kernel v2.2.3** · Soumalya Das · 2026

</div>
