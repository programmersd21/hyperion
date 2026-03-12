<div align="center">

<pre style="font-size:1.1em; line-height:1.2em; color:#FFA500;">
 ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ██╗ ██████╗ ███╗   ██╗
 ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██║██╔═══██╗████╗  ██║
 ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝██║██║   ██║██╔██╗ ██║
 ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██║██║   ██║██║╚██╗██║
 ██║  ██║   ██║   ██║     ███████╗██║  ██║██║╚██████╔╝██║ ╚████║
 ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                  <strong style="color:#1e88e5;">H Y P E R I O N · v2.2.0</strong>
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
<img src="https://img.shields.io/badge/kernel-6.19.6--Hyperion--2.2.1-blue?style=for-the-badge&color=43a047" alt="Kernel Version">
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
- [What's New in v2.2.1](#whats-new-in-v221)
  - [v2.2.1 -- Arch ISO Boot Pipeline & Wayland Graphics Pass](#v221----arch-iso-boot-pipeline--wayland-graphics-pass)
  - [v2.2.1 -- USB Stability & Autosuspend Elimination](#v221----usb-stability--autosuspend-elimination)
  - [v2.1.0 -- Precision Tuning Pass](#v210--precision-tuning-pass)
  - [v2.0.2 -- Universal Daily-Driver Pass](#v202--universal-daily-driver-pass)
- [Philosophy](#philosophy)
- [Key Features](#key-features)
- [Monolithic Architecture](#monolithic-architecture)
- [Hardware Support](#hardware-support)
  - [Wi-Fi -- Universal Chipset Coverage](#wi-fi--universal-chipset-coverage)
  - [Bluetooth](#bluetooth)
  - [Thunderbolt & USB4](#thunderbolt--usb4)
  - [GPU & Display](#gpu--display)
  - [Audio -- SoC & Laptop Audio](#audio--soc--laptop-audio)
  - [Input, Tablets & Stylus](#input-tablets--stylus)
  - [Webcam & Media](#webcam--media)
  - [Storage](#storage)
  - [Networking](#networking)
- [USB Power Management](#usb-power-management)
  - [Root Cause](#root-cause)
  - [Five-Layer Defence Strategy](#five-layer-defence-strategy)
  - [Companion Files](#companion-files)
  - [Verifying USB Power State](#verifying-usb-power-state)
- [Virtualization & Waydroid](#virtualization--waydroid)
- [Security](#security)
- [Performance Goals](#performance-goals)
- [Stability Goals](#stability-goals)
- [Power Management](#power-management)
- [Module & DKMS Compatibility](#module--dkms-compatibility)
- [Distro Compatibility](#distro-compatibility)
- [Supported Architectures](#supported-architectures)
- [Quick Start](#quick-start)
- [Build Instructions](#build-instructions)
- [Installation](#installation)
- [Companion Files Installation](#companion-files-installation)
- [Recommended Boot Parameters](#recommended-boot-parameters)
- [Development Workflow](#development-workflow)
- [Troubleshooting](#troubleshooting)
- [Credits](#credits)
- [License](#license)

---

## Overview

**Hyperion Kernel** is a custom Linux 6.19.6 kernel build engineered to be the definitive daily-driver kernel for every kind of Linux user -- gamers, developers, modders, tinkerers, and hobbyists. It combines the best configuration practices from CachyOS, XanMod, Nobara, Liquorix, and upstream Linux into a single, fully integrated, zero-compromise `bzImage`.

**v2.2.1 is the "Persistent Beast" release** -- a focused pass on USB peripheral stability, low-latency input polling, and sub-millisecond scheduler precision. If you have ever experienced a dropped first keypress after a pause, a USB DAC clicking on resume, a mouse stuttering after two seconds of idle, or a USB audio device silently disconnecting from PipeWire -- this release is the fix. It addresses all of these at every layer from kernel compile-time defaults down to userspace udev rules.

Hyperion v2.2.1 is designed for:

- **Gamers** -- PREEMPT, SCHED_HRTICK, sched_ext, UCLAMP, BBR, 1 kHz input polling, zero USB-sleep input drops, and full Waydroid Android gaming
- **Developers** -- KPROBES, UPROBE_EVENTS, bpftrace/bcc support, LIVEPATCH for zero-downtime CVE fixes, full DKMS compatibility, and KVM with OVMF/UEFI
- **Audio producers** -- USB DAC autosuspend permanently disabled, PipeWire at 64-frame quanta via SCHED_HRTICK, SoC audio for every modern laptop, JACK-ready low-latency path
- **Modders & Tinkerers** -- every Wi-Fi chipset, every Bluetooth adapter, every GPU built-in; HID_STEAM, HID_NINTENDO, and all drawing tablets
- **Distro-agnostic users** -- SELinux (Fedora/RHEL), AppArmor (Ubuntu/Arch), TOMOYO (openSUSE) all compiled in with zero reconfiguration needed

```
uname -r  ->  6.19.6-Hyperion-2.2.1
uname -v  ->  #1 SMP PREEMPT Linux 6.19.6-Hyperion-2.2.1 (Soumalya Das) 2026
```

---

## What's New in v2.2.1

### v2.2.1 -- Arch ISO Boot Pipeline & Wayland Graphics Pass

> The "make the boot chain complete and provably correct" pass.

This pass audited the full boot-to-compositor pipeline against a published
checklist of 39 required kernel options and resolved every gap found.

The kernel's role in a Wayland desktop is to act as a device manager. It
exposes GPU buffer nodes and input event nodes; userspace (Mesa, libinput,
wlroots, Hyprland) builds the entire graphical world on top of those two
primitive streams. The checklist maps every layer of that chain:

```
bootloader
  -> Hyperion kernel (PCI, ACPI, EFI)
  -> storage driver (NVMe, SATA)
  -> root filesystem (EXT4, BTRFS)
  -> [live boot only] loop device -> squashfs -> overlayfs -> tmpfs
  -> systemd (devtmpfs, cgroups)
  -> DRM/KMS (/dev/dri/card0, /dev/dri/renderD128)
  -> input subsystem (/dev/input/event*)
  -> Wayland compositor (Hyprland)
```

Audit result: 36 of 39 options were already correctly set. Three were missing.

| Option added | Layer | Why it was missing and why it matters |
|---|---|---|
| `CONFIG_BLK_DEV_LOOP=y` | Live boot | The loop device driver is the single most critical option for Arch ISO boot. airootfs.sfs is mounted through a loop device; without this the boot fails with `losetup: failed to set up loop device` and never reaches squashfs. Must be `=y`, not `=m`, because a module cannot load before the squashfs root it would be stored on is available. |
| `CONFIG_BLK_DEV_LOOP_MIN_COUNT=8` | Live boot | Pre-allocates 8 loop device nodes at boot. archiso needs at least 1 for airootfs.sfs. 8 leaves headroom for AppImage mounts, additional squashfs layers, and live-session package operations. |
| `CONFIG_NVME_CORE=y` | Storage | The shared core library all NVMe transports link against. Kconfig normally auto-selects it as a dependency of BLK_DEV_NVME, but the dependency resolution is not guaranteed when building from a custom config with `make olddefconfig`. Making it explicit ensures it is built-in regardless of resolution order. |

Additionally, this pass added the full Wayland/Hyprland/archiso infrastructure
block (DMA-BUF, SYNC_FILE, UDMABUF, DMABUF_HEAPS, SIMPLEDRM, SYSFB, overlayfs
sub-options, input completeness, and seccomp for Flatpak sandboxing) documented
in the v2.2.1 config under the Wayland/Hyprland/archiso pass section.

---

### v2.2.1 -- USB Stability & Autosuspend Elimination

> The "stop killing my keyboard, my mouse, and my DAC" release.

#### USB Core

| Change | Impact |
|---|---|
| `CONFIG_USB_AUTOSUSPEND_DELAY=-1` | Kernel compile-time default changed from 2 seconds to never. Every USB device on every port boots with autosuspend off -- no race against udev, no initramfs ordering problem, no TLP config sneaking it back in at the wrong moment. |
| `USB_DEFAULT_PERSIST=y` annotated | Documents exactly why persistence across suspend matters: no full disconnect/reconnect on wake, keyboard LED state survives sleep, USB audio DAC skips the 500 ms re-enumeration delay. |
| xHCI autosuspend root-cause documented | Explains why USB3 specifically is worse: the xHCI spec permits aggressive port power-gating that EHCI never did. This is the underlying reason RTL8153 USB-Ethernet, wireless dongles, and DACs started dropping more frequently post-2021. |
| Five-layer defence strategy | Full documentation of every layer: Kconfig default, kernel cmdline, udev rules, modprobe.d, and sysfs verification. Each layer catches failures the previous one might miss. |
| USB audio (`SND_USB_AUDIO`) annotated | Adds `implicit_fb=1` and `ignore_ctl_error=1` modprobe options for async USB DACs that disconnect after silence or misreport their sync endpoint type. |
| Class-based udev rules template | Copy-paste-ready `/etc/udev/rules.d/99-usb-power.rules` matching HID (class 0x03), audio (class 0x01), and hub (class 0x09) devices specifically. |

#### Input Polling

| Parameter | Effect |
|---|---|
| `usbhid.mousepoll=1` | Drops USB mouse poll interval from 8 ms (125 Hz) to 1 ms (1000 Hz). Sub-1 ms input latency for gaming mice. |
| `usbhid.kbpoll=1` | Drops USB keyboard poll interval from 10 ms (100 Hz) to 1 ms. Eliminates dropped keystrokes during scheduler latency spikes under heavy CPU load. |
| `usbhid.jspoll=1` | Drops USB gamepad poll interval to 1 ms. At 8 ms poll, a fighting game frame window (16 ms at 60 FPS) is already 50% consumed before the kernel sees the button press. |

#### Gaming Controllers

| Addition | What it enables |
|---|---|
| `HID_STEAM=y` | Valve Steam Controller and Steam Deck gamepad -- proper HID gamepad with gyro, trackpad, and haptic feedback. Steam Input picks it up cleanly without raw mouse/keyboard fallback. |
| `HID_NINTENDO=y` | Nintendo Switch Pro Controller and Joy-Con (L/R) over USB and Bluetooth, including IMU (gyroscope + accelerometer) exposed via the IIO subsystem. Works with Steam and standalone udev mapping tools. |
| `JOYSTICK_HRTIMER=y` | Gamepad polling backed by hrtimers, enabling true 1 kHz+ polling rates on DualSense and Xbox Series controllers. |

---

### v2.1.0 -- Precision Tuning Pass

#### Scheduler

| Change | Impact |
|---|---|
| `SCHED_HRTICK=y` | Scheduler can now preempt at hrtimer resolution, not just at HZ=1000 tick boundaries. Critical for PipeWire 64-frame quanta (1.3 ms at 48 kHz) and frame pacing above 120 FPS. |
| `PREEMPT_LAZY=y` | Linux 6.12's fourth preemption mode. Switch at boot: `preempt=lazy` for compile sessions, `preempt=full` for gaming. No recompile needed. |
| `RCU_LAZY=y` | Coalesces RCU callbacks on `nohz_full` CPUs instead of forcing a tick to flush them -- reduces interrupt noise on isolated gaming cores. |

#### Memory

| Change | Impact |
|---|---|
| `HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y` | Frees 7 `struct page` entries (448 bytes) per 2 MB THP. Meaningful RAM savings when games or JVMs allocate hundreds of thousands of huge pages. |
| `ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y` | Batches TLB shootdown IPIs before firing. Reduces inter-core ping-pong overhead during Vulkan multi-threaded command submission. |

#### Developer & Observability

| Change | Impact |
|---|---|
| `KPROBES=y` + `KRETPROBES=y` | Dynamic kernel probe points. Zero overhead when no probes are set. |
| `KPROBE_EVENTS=y` + `UPROBE_EVENTS=y` | `bcc` tools (`execsnoop`, `opensnoop`, `biolatency`), `bpftrace`, and `perf probe` all work without additional configuration. Enables tracing Java, Go, Rust, and C++ function calls at runtime with zero source changes. |
| `LIVEPATCH=y` | Apply security fixes to a running kernel without rebooting running VMs, games, or compile jobs. Compatible with `kpatch` and distribution kernel-livepatch packages. |
| `PAGE_POOL=y` + `PAGE_POOL_STATS=y` | Per-NIC page recycling pool. Intel, Mellanox, and AMD NICs reuse receive pages instead of alloc/free per packet -- essential for XDP zero-copy receive at line rate. |
| `ETHTOOL_NETLINK=y` | Modern netlink ethtool API. Required by ethtool 5.x+, NetworkManager, and iproute2 for ring size, coalesce, and RSS configuration. |
| `NET_SOCK_MSG=y` + `SOCK_MAP=y` | BPF sockmap for Cilium eBPF load balancing, Envoy proxy acceleration, and zero-copy inter-process socket redirection. |
| `SKB_EXTENSIONS=y` | Per-packet metadata extension slots used by TC flower, XDP metadata passes, and WireGuard cookie mechanism. |

#### Crypto & Power

| Change | Impact |
|---|---|
| `CRYPTO_BLAKE2B=y` + `CRYPTO_BLAKE2S=y` | Used by BTRFS `b2` checksums, `restic` backups, WireGuard PSK hashing, and `systemd-homed`. Faster than SHA-256 in software on x86_64 with AVX2. |
| `CRYPTO_GHASH_CLMUL_NI_INTEL=y` | Made explicitly built-in. Hardware PCLMULQDQ-accelerated GHASH for AES-GCM (TLS 1.3, QUIC, dm-crypt). ~10x faster than software. |
| `AMD_PMF=y` | AMD Platform Management Framework for Zen 4+ laptops. Enables SmartShift eco/performance profiles and AMD Advantage features on Rembrandt, Phoenix, and Hawk Point platforms. |
| `ACPI_CPPC_CPUFREQ_FAST_SWITCH=y` | P-state transitions from IRQ/scheduler context without a context switch. Eliminates the latency spike when the scheduler tries to boost a core mid-game-loop. |

---

### v2.0.2 -- Universal Daily-Driver Pass

> 39 new config groups, 5 new subsystems, full distro compatibility. Full changelog below for reference.

#### Security -- Multi-LSM Support
| Addition | Impact |
|---|---|
| `CONFIG_SECURITY_SELINUX=y` + full parameter block | Fedora, RHEL, CentOS, Rocky, Alma, and Android-lineage distros work perfectly. Boot with `security=selinux` to activate. |
| `CONFIG_SECURITY_TOMOYO=y` | Pathname-based MAC for openSUSE and Debian. Zero overhead when not active. |
| AppArmor remains default LSM | Ubuntu, Arch, and Debian users experience no change. All three LSMs compiled in; distro chooses via cmdline. |

#### Wi-Fi -- Universal Chipset Coverage
| Addition | Chipsets Covered |
|---|---|
| `CONFIG_ATH9K=y` + HTC/PCI/USB | Qualcomm/Atheros AR9xxx -- 802.11n |
| `CONFIG_ATH10K=y` + PCI/USB/SDIO | Qualcomm QCA9xxx/WCN3990 -- 802.11ac |
| `CONFIG_ATH11K=y` + PCI/AHB | Qualcomm QCN6122/WCN6855 -- Wi-Fi 6 |
| `CONFIG_ATH12K=y` | Qualcomm QCN9274/WCN7850 -- Wi-Fi 7 |
| `CONFIG_RTW88=y` + all variants | Realtek RTL8822B/C, RTL8821C, RTL8723D |
| `CONFIG_RTW89=y` + all variants | Realtek RTL8852A/B/C, RTL8851B -- Wi-Fi 6/6E |
| `CONFIG_MT7925_COMMON=y` + E/U | MediaTek Wi-Fi 7 -- 2024+ laptop platforms |
| `CONFIG_BRCMSMAC=y` | Broadcom SoftMAC -- Apple/hybrid platform compatibility |

#### New Subsystems (all previously absent)
- **Thunderbolt/USB4** -- eGPU docks, TB networking, USB4 hubs
- **WireGuard** -- built-in, ~10 Gbps, no module-load race
- **Webcam & Media** -- UVC, V4L2, CEC, DVB, IR receivers
- **SoC Audio** -- Intel SOF (ICL/TGL/ADL/MTL), AMD ACP, RT5682, CS35L41
- **Drawing tablets** -- Wacom, XP-Pen, Huion, Gaomon via UCLogic

#### Virtualization Fixes
| Addition | Impact |
|---|---|
| `CONFIG_KVM_SMM=y` | OVMF/EDK2 UEFI guests now POST -- was silently failing |
| `CONFIG_KVM_HYPERV=y` | Windows 10/11 VMs gain 20-40% performance |
| `CONFIG_VSOCK_LOOPBACK=y` | Waydroid clipboard, ADB, and full-UI were silently broken -- now fixed |
| `CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y` | VM/container DHCP and DNS silent drop bug fixed |

---

## Philosophy

> *"A kernel should never be the reason your work stopped."*

Hyperion is built on five principles:

1. **No Silent Deaths** -- Every OOM event, lockup, and crash is logged and recoverable. No mystery reboots.
2. **Headers Always Present** -- Kernel headers are built and installed as a first-class artifact. DKMS modules build on the first try, every time.
3. **Performance Without Sacrifice** -- Every nanosecond of latency and every MB/s of throughput is extracted from the hardware, but never at the cost of correctness or stability.
4. **Developer First** -- Config is fully documented with sources. Every decision is explainable. This is a kernel you can learn from and contribute to.
5. **Universal by Default** -- If it is a mainstream Linux distribution or a mainstream piece of hardware, it works on Hyperion without configuration.

---

## Key Features

| Category | Feature | Details |
|---|---|---|
| **Identity** | Custom branding | `uname -r` -> `6.19.6-Hyperion-2.2.1` |
| **Build** | Monolithic image | All in-tree modules promoted to `=y` -- zero module-load latency |
| **Build** | ZSTD compression | ~40% faster boot than GZIP on NVMe (Phoronix) |
| **Build** | KALLSYMS_ALL | Full symbol table -- required for sched_ext BPF introspection |
| **Scheduler** | Full preemption | `CONFIG_PREEMPT=y` + `PREEMPT_DYNAMIC=y` + `PREEMPT_LAZY=y` -- lowest latency desktop |
| **Scheduler** | Sub-ms ticks | `SCHED_HRTICK=y` -- hrtimer-resolution preemption for PipeWire and 120+ FPS gaming |
| **Scheduler** | sched_ext (scx) | BPF-swappable schedulers: scx_bpfland, scx_lavd, scx_rusty at runtime |
| **Scheduler** | Autogroup | `SCHED_AUTOGROUP=y` -- session-aware interactive scheduling |
| **Scheduler** | UCLAMP | CPU capacity clamping -- games pin to fast cores, background tasks stay quiet |
| **Scheduler** | Task isolation | `SCHED_ISOLATION=y` -- per-task nohz_full isolation hints |
| **Scheduler** | IRQ threading | `IRQ_FORCED_THREADING=y` -- scheduler owns all IRQ timing |
| **Timer** | 1000 Hz tick | `CONFIG_HZ_1000=y` -- 1 ms scheduler granularity |
| **Timer** | NO_HZ_FULL | Adaptive tickless + `RCU_NOCB_CPU` + `RCU_LAZY` -- callbacks off isolated CPUs |
| **Timer** | High-res timers | Sub-millisecond precision for audio, game frame pacing |
| **USB** | Autosuspend off | `USB_AUTOSUSPEND_DELAY=-1` -- no USB device ever idles to sleep by default |
| **USB** | Device persist | `USB_DEFAULT_PERSIST=y` -- device state survives system sleep/wake |
| **USB** | 1 kHz polling | `usbhid.mousepoll/kbpoll/jspoll=1` via cmdline -- all HID at 1000 Hz |
| **Memory** | MGLRU + MMU walk | `LRU_GEN_WALKS_MMU=y` -- accurate cold-page detection, fewer false evictions |
| **Memory** | THP optimization | `HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y` -- 448 bytes saved per 2 MB huge page |
| **Memory** | Batched TLB flush | `ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y` -- coalesced TLB shootdowns |
| **Memory** | DAMON | Intelligent memory access monitoring + proactive reclaim |
| **Memory** | ZSWAP ZSTD | Compressed in-RAM swap -- defeats OOM before it starts |
| **Memory** | THP MADVISE | Opt-in transparent huge pages -- best of both worlds |
| **Memory** | SLAB_BUCKETS | Reduced SLUB fragmentation for mixed-size alloc patterns |
| **IO** | BFQ scheduler | Best desktop/gaming IO fairness (default) |
| **IO** | Kyber scheduler | Lowest NVMe queue latency |
| **IO** | io_uring | Built-in -- zero module-load delay for every async IO path |
| **IO** | CAKE qdisc | Best-in-class bufferbloat elimination for home broadband |
| **Network** | BBR (default) | Google's low-latency TCP congestion control |
| **Network** | FQ scheduler | Per-flow fair queuing -- games never queue behind bulk transfers |
| **Network** | WireGuard | Built-in modern VPN -- ~10 Gbps with ChaCha20-NI |
| **Network** | PAGE_POOL | Per-NIC page recycling -- no alloc/free per packet at line rate |
| **Network** | MPTCP | Multi-path TCP -- use multiple interfaces simultaneously |
| **Network** | TCP Fast Open | -1 RTT on repeat connections |
| **Network** | BPF sockmap | `SOCK_MAP=y` -- zero-copy socket redirection for Cilium/Envoy |
| **CPU** | AMD P-State Active | Optimal Zen3/4 boost (mode 3 Active EPP) |
| **CPU** | AMD PMF | SmartShift and platform profiles for Zen 4+ laptops |
| **CPU** | Intel P-State + HWP | Hardware-managed boost, lower software overhead |
| **CPU** | NUMA spinlocks | `NUMA_AWARE_SPINLOCKS=y` -- less lock bouncing on Zen multi-CCX |
| **CPU** | CPPC fast switch | Frequency transitions from IRQ context -- no context-switch overhead |
| **GPU** | AMDGPU full | DC, FP, HDCP, FreeSync, ROCm/HSA -- all built-in |
| **GPU** | Intel i915 + Xe | Intel Arc/Tiger Lake+ full support |
| **GPU** | Nouveau | Open NVIDIA driver for Turing/Ampere/Lovelace display |
| **Crypto** | AES-NI/AVX | Built-in -- ~10x software speed, available from first call |
| **Crypto** | BLAKE2B/BLAKE2S | Modern fast hash -- BTRFS b2, restic, WireGuard PSK |
| **Crypto** | GHASH CLMUL-NI | Hardware-accelerated AES-GCM for TLS 1.3, QUIC, dm-crypt |
| **Crypto** | ChaCha20/Poly1305 | Built-in WireGuard and TLS 1.3 -- no module load needed |
| **Storage** | NVMe-oF full | TCP + RDMA + FC -- all three transports built-in |
| **Storage** | NVME_CORE explicit | `CONFIG_NVME_CORE=y` -- NVMe core library made explicit; guaranteed built-in regardless of Kconfig dependency resolution order |
| **Storage** | FSCACHE/CACHEFILES | Persistent local cache for NFS/CIFS -- survives reconnection |
| **Live boot** | Loop devices | `BLK_DEV_LOOP=y` built-in -- Arch ISO can mount airootfs.sfs; `LOOP_MIN_COUNT=8` pre-allocates nodes at boot |
| **Gaming** | HID_STEAM | Valve Steam Controller / Steam Deck gamepad |
| **Gaming** | HID_NINTENDO | Switch Pro / Joy-Con over USB and Bluetooth with IMU |
| **Gaming** | JOYSTICK_HRTIMER | hrtimer-backed gamepad polling for true 1 kHz+ rates |
| **Dev** | KPROBES + UPROBES | Dynamic kernel and userspace probes for bpftrace/bcc |
| **Dev** | LIVEPATCH | Live kernel patching -- no reboot for security fixes |
| **Wi-Fi** | Universal coverage | ATH9K/10K/11K/12K + RTW88/89 + MT7921/7925 + IWLWIFI |
| **Bluetooth** | Universal UART | Intel/QCA/BCM/MRVL UART drivers -- all modern laptop BT |
| **Thunderbolt** | TB3/4 + USB4 | eGPU, TB networking, USB4 hubs all work |
| **Audio** | SOF + HDA + AMD | Ice Lake through Meteor Lake SOF, AMD ACP, RT5682, CS35L41 |
| **Webcam** | USB UVC | Every USB webcam, V4L2 mem2mem, CEC, DVB, IR |
| **Tablets** | Wacom + UCLogic | Full Wacom pen support + XP-Pen/Huion/Gaomon |
| **Modules** | IKHEADERS | In-kernel headers always available at runtime |
| **Modules** | MODVERSIONS | Symbol versioning -- mismatches caught at load, not panic |
| **Security** | AppArmor (default) | Application sandboxing -- Ubuntu/Arch/Debian |
| **Security** | SELinux | Mandatory access control -- Fedora/RHEL/CentOS |
| **Security** | TOMOYO | Pathname MAC -- openSUSE/Debian |
| **Security** | Landlock | Process-level filesystem sandboxing |
| **Security** | LIVEPATCH | Zero-downtime CVE patching |
| **Security** | Hardened usercopy | Strict object boundary enforcement |
| **Security** | Kstack randomise | `RANDOMIZE_KSTACK_OFFSET=y` -- kills stack-layout exploits |
| **Security** | Stack zero-init | `INIT_STACK_ALL_ZERO=y` -- kills uninitialised data leaks |
| **UEFI** | EFI stub | Kernel IS the EFI executable -- no bootloader shim needed |
| **UEFI** | EFIVAR_FS built-in | Available before initramfs -- `efibootmgr` works from early boot |
| **Power** | ACPI platform profile | `power-profiles-daemon` power slider in GNOME/KDE works |
| **Power** | AMD PMC | Ryzen laptop s2idle (modern standby) -- no battery drain on suspend |
| **Power** | AMD HSMP | Per-CCX power limits and fabric bandwidth telemetry |
| **Debug** | Lockup detection | Soft + hard lockup watchdog, hung task detection |
| **Debug** | PSI | Pressure stall info -- see resource saturation before OOM |
| **Debug** | pstore | Kernel panic logs survive reboots via RAM backend |

---

## Monolithic Architecture

Every in-tree driver and subsystem that was previously a loadable module (`=m`) has been compiled directly into the `bzImage`. This is a deliberate and permanent design choice -- the kernel carries everything it needs from the very first instruction.

**What was integrated:**
- **All in-tree modules** promoted from `=m` -> `=y`
- `KALLSYMS_ALL=y` -- full kernel symbol table exposed (all symbols are in-tree; safe)
- `EFIVAR_FS=y` -- was `=m`; now available before initramfs for `efibootmgr`
- All crypto primitives (AES-NI, ChaCha20, Poly1305, BLAKE2), NVMe-oF transports (TCP/RDMA/FC), FSCACHE, Bluetooth stack, and all Wi-Fi chipset drivers built-in

**What was NOT changed:**
- `CONFIG_MODULES=y` is retained -- DKMS external modules (NVIDIA, ZFS, v4l2loopback) still insert normally
- `CONFIG_MODULE_UNLOAD=y` -- DKMS reinstall still works without rebooting
- `CONFIG_MODVERSIONS=y` -- ABI mismatch protection enforced at `insmod`, not discovered at runtime

**Trade-offs:**
- `bzImage` is larger -- expected and acceptable on any modern system (target: `<15 MB` compressed ZSTD)
- Initramfs module loads for hardware support are no longer needed -- boot is faster
- Cold-boot to usable userspace is reduced because no module-load phase exists for in-tree devices

---

## Hardware Support

### Wi-Fi -- Universal Chipset Coverage

Every major Wi-Fi vendor across every generation is built-in. If you have a laptop or desktop with Wi-Fi made between 2012 and 2026, it works on first boot.

| Vendor | Driver | Standards | Notable Hardware |
|---|---|---|---|
| Qualcomm/Atheros | `ATH9K` (PCI+USB+HTC) | 802.11n | AR9280, AR9285, AR9287, AR9380 -- embedded/budget laptops |
| Qualcomm/Atheros | `ATH10K` (PCI+USB+SDIO) | 802.11ac | QCA6174, QCA9377, QCA9880, WCN3990 |
| Qualcomm/Atheros | `ATH11K` (PCI+AHB) | Wi-Fi 6 (ax) | QCN6122, WCN6855 -- 2021+ mid-range laptops |
| Qualcomm/Atheros | `ATH12K` | Wi-Fi 7 (be) | QCN9274, WCN7850 -- cutting-edge platforms |
| Realtek | `RTW88` (PCI+USB) | 802.11ac | RTL8822B/C, RTL8821C, RTL8723D |
| Realtek | `RTW89` (PCI+USB) | Wi-Fi 6/6E | RTL8852A/B/C, RTL8851B -- most 2022+ Realtek laptops |
| Realtek | Legacy stack | 802.11n/ac | RTL8192CE/EE, RTL8723BE, RTL8812AE, RTL8821AE |
| Intel | `IWLWIFI` (DVM+MVM) | 802.11ac/ax | AX200, AX210, AX211, 9260, 8265, 7265 |
| MediaTek | `MT7921` E/U/S | Wi-Fi 6 | MT7921 PCIe, USB, SDIO variants |
| MediaTek | `MT7925` E/U | Wi-Fi 7 | 2024+ laptop platforms |
| MediaTek | `MT7603E`, `MT7615` | 802.11n/ac | Older MediaTek AP/router chipsets |
| Broadcom | `BRCMFMAC` | 802.11ac | BCM43xx -- Apple, some Lenovo |
| Broadcom | `BRCMSMAC` | 802.11n | SoftMAC Broadcom -- Apple hybrid compatibility |
| Ralink | `RT2X00` (PCI+USB) | 802.11n | RT2800 family |
| TI | `WL18XX` / `WLCORE` | 802.11n | TI WiLink embedded chips |

### Bluetooth

All modern laptop Bluetooth chips communicate via UART serial transport.

| Driver | Transport | Hardware Covered |
|---|---|---|
| `BT_HCIBTUSB` + BCM/RTL | USB dongle | Most USB Bluetooth adapters, Broadcom/Realtek dongles |
| `BT_HCIUART` + H4 | UART | Generic UART Bluetooth |
| `BT_HCIUART` + Intel | UART | Intel AX200/AX210/AX211 Bluetooth coex |
| `BT_HCIUART` + QCA | UART | Qualcomm WCN685x and all QCA UART BT |
| `BT_HCIUART` + BCM | UART | Broadcom embedded Bluetooth (Apple, some laptops) |
| `BT_INTEL` | PCIe/USB | Intel Bluetooth with full RF coexistence management |
| `BT_HCIBTSDIO` | SDIO | Tablet and embedded platform Bluetooth |
| `BT_MSFTEXT` | Protocol ext | Xbox controller audio, Microsoft BT extensions |

### Thunderbolt & USB4

| Feature | Config | Description |
|---|---|---|
| Thunderbolt host controller | `THUNDERBOLT=y` | TB3/TB4: eGPU enclosures, docks, NVMe, Blackmagic, Elgato |
| Thunderbolt networking | `THUNDERBOLT_NET=y` | Direct 40 Gbps IP link between two machines over TB cable |
| USB4 host controller | `USB4=y` | USB4 Gen 2x2 and Gen 3x2 -- covers USB4 hubs and tunneled NVMe |
| USB4 networking | `USB4_NET=y` | IP networking over USB4 cable |

### GPU & Display

| Driver | Hardware | Features |
|---|---|---|
| `DRM_AMDGPU` | AMD GCN1 through RDNA3 | Full display core (DC/FP/HDCP), FreeSync, ROCm/HSA compute |
| `DRM_I915` | Intel Gen4 through Xe (Arc) | Full GuC/HuC firmware, HDMI/DP, SR-IOV |
| `DRM_XE` | Intel Arc/Battlemage | New Intel Xe DRM driver (Arc A-series and beyond) |
| `DRM_NOUVEAU` | NVIDIA Turing/Ampere/Lovelace | Open display driver -- display output without proprietary blob |
| `DRM_VIRTIO_GPU` | QEMU/KVM guests | VirtIO GPU for VM accelerated display |
| `DRM_VMWGFX` | VMware guests | VMware SVGA II + DX acceleration |
| `DRM_VKMS` | Headless/CI | Virtual KMS -- useful for CI/testing without a display |

NVIDIA proprietary support: install the NVIDIA DKMS module (`nvidia-dkms` package) as usual -- the module infrastructure is fully retained.

### Audio -- SoC & Laptop Audio

Legacy HDA (desktop motherboards, older laptops) is handled by `SND_HDA_INTEL` with full codec support (Realtek, Analog, Sigmatel, Via, Conexant, HDMI). Modern laptops (2019 onwards) use the SoC/DSP path:

| Platform | Config | Laptops Covered |
|---|---|---|
| Intel Ice Lake | `SOF_ICELAKE=y` | 10th gen Intel (late 2019) |
| Intel Tiger Lake | `SOF_TIGERLAKE=y` | 11th gen Intel (2020-2021) -- majority of current systems |
| Intel Alder Lake | `SOF_ALDERLAKE=y` | 12th gen Intel (2022) |
| Intel Meteor Lake | `SOF_METEORLAKE=y` | 13th/14th gen Intel (2023-2024) |
| Intel Skylake/KBL | `INTEL_SKL=y` + `INTEL_KBL=y` | 6th/7th gen Intel (2015-2017) |
| AMD Renoir/Cezanne | `AMD_ACP3x=y` | AMD Ryzen 4000/5000 laptops |
| AMD Yellow Carp | `AMD_ACP6x=y` | AMD Ryzen 6000 laptops |
| AMD Pink Sardine | `AMD_PS=y` | AMD Ryzen 7000 laptop platform |
| RT5682/RT5682S | codec | Virtually every Intel/AMD laptop 2020+ |
| CS35L41 | codec | Dell XPS, Lenovo ThinkPad, HP EliteBook smart amp |
| NAU8825 | codec | Chromebooks and ultrabooks |
| MAX98357A | codec | Class-D amp in many tablet/Chromebook platforms |

USB audio and HDMI audio are always built-in via `SND_USB_AUDIO` and `SND_HDA_CODEC_HDMI`.

**USB audio stability note:** USB DACs and audio interfaces are particularly sensitive to autosuspend. With `USB_AUTOSUSPEND_DELAY=-1` and the class-based udev rule for `bDeviceClass=="01"`, DACs stay in D0 at all times. No click transients on resume, no ALSA xruns after silence, no PipeWire device-lost errors. See the [USB Power Management](#usb-power-management) section for the full setup.

For async USB DACs that still drop connection, add to `/etc/modprobe.d/snd-usb-audio.conf`:
```
options snd-usb-audio implicit_fb=1 ignore_ctl_error=1
```

### Input, Tablets & Stylus

| Driver | What it supports |
|---|---|
| `HID_WACOM` | Full Wacom pen: Intuos, Cintiq, Bamboo, MobileStudio -- pressure, tilt, eraser, proximity, barrel buttons |
| `HID_UCLOGIC` | XP-Pen, Huion (2018+), Gaomon, UGEE, Veikk -- all use UCLogic protocol internally |
| `HID_HUION` | Older Huion models (pre-UCLogic protocol) |
| `HID_PLAYSTATION` | DualShock 4, DualSense -- haptics, adaptive triggers, touchpad |
| `HID_SONY` | Legacy Sony HID devices |
| `HID_STEAM` | Valve Steam Controller and Steam Deck -- gyro, trackpad, haptics |
| `HID_NINTENDO` | Switch Pro Controller, Joy-Con -- USB and BT, includes IMU via IIO |
| `HID_LOGITECH_HIDPP` | Logitech G-series gaming mice, MX Master series |
| `JOYSTICK_XPAD` + FF | Xbox controllers (wired, wireless via USB dongle) with rumble |
| `HID_RAZER` | Razer mice, keyboards, Tartarus, Orbweaver |
| `HID_CORSAIR` | Corsair gaming peripherals |
| `HID_ROCCAT` | Roccat mice and keyboards |
| `HID_THRUSTMASTER` | Thrustmaster racing wheels and HOTAS |
| `JOYSTICK_HRTIMER` | hrtimer-backed polling -- enables 1 kHz+ on DualSense/Xbox Series |
| `HIDRAW` | libfprint fingerprint readers, fwupd/LVFS, OpenRGB, Piper |
| `INPUT_EVDEV` | `/dev/input/eventN` -- required by all Wayland compositors and X11 |
| `RMI4` | Synaptics precision touchpads over SMBus/I2C |
| Touchscreen | Atmel MXT, Goodix, Elan, EDT FT5x06, USB composite |

### Webcam & Media

| Feature | Config | Notes |
|---|---|---|
| USB webcam | `USB_VIDEO_CLASS=y` | UVC: every USB webcam made after 2005 |
| V4L2 hw encode/decode | `V4L2_MEM2MEM_DEV=y` | VA-API (Intel QSV, AMD VCE), VDPAU |
| HDMI CEC | `CEC_CORE=y` | TV auto-power, HDMI ARC, receiver passthrough |
| DVB/TV tuners | `DVB_CORE=y` | Hauppauge, Geniatech, RTL2832U-based sticks |
| SDR dongle base | DVB infrastructure | RTL-SDR dongles use libusb directly; DVB base needed |
| IR remote | `RC_CORE=y` | FLIRC, Hauppauge, Windows MCE receivers |
| Video buffer | `VIDEOBUF2_*=y` | Unified DMA-contiguous and vmalloc buffer management |

### Storage

| Feature | Config | Notes |
|---|---|---|
| NVMe (PCIe) | `BLK_DEV_NVME=y` | All NVMe SSDs, multipath, hardware monitor, auth |
| NVMe over TCP | `NVME_TCP=y` | Network-attached NVMe, diskless boot |
| NVMe over RDMA | `NVME_RDMA=y` | HPC/cloud zero-copy NVMe-oF |
| NVMe over FC | `NVME_FC=y` | Enterprise Fibre Channel SAN |
| SATA AHCI | `SATA_AHCI=y` | All AHCI SATA controllers |
| SCSI multi-queue | `SCSI_MQ_DEFAULT=y` | Per-CPU I/O queues, near-linear scaling |
| UFS | `SCSI_UFSHCD=y` | UFS storage (phones, tablets, embedded) |
| RAID | MD RAID 0/1/5/6/10 | Software RAID -- built-in |
| LVM/dm-crypt | `BLK_DEV_DM=y` + `DM_CRYPT=y` | Full LVM, dm-crypt, dm-integrity |
| Zoned storage | `BLK_DEV_ZONED=y` | ZNS NVMe and SMR HDDs |
| Write-back cache | `DM_WRITECACHE=y` | Transparent SSD cache in front of HDD |
| Per-block integrity | `DM_INTEGRITY=y` | HMAC protection against silent data corruption |
| Android OTA | `DM_USER=y` | Virtual A/B OTA snapshot for Waydroid |

Filesystems built-in: **ext4, ext3, XFS, Btrfs, F2FS, NTFS3, exFAT, vFAT, squashfs, EROFS, overlay, FUSE, ISO9660, NFS v2/v3/v4.x, CIFS/SMB, AFS, 9P/VirtioFS**.

### Networking

| Feature | Config | Notes |
|---|---|---|
| WireGuard VPN | `WIREGUARD=y` | Built-in, ~10 Gbps, zero module-load race |
| L2TP/L2TPv3 | `L2TP=y` + v3/IP/ETH | Enterprise/ISP VPN protocols |
| BBR (default) | `DEFAULT_BBR=y` | Google's congestion control -- kills bufferbloat |
| CAKE | `NET_SCH_CAKE=y` | Best AQM qdisc for home broadband asymmetric links |
| MPTCP | `MPTCP=y` | Use multiple NICs/interfaces for one connection |
| TCP Fast Open | `TCP_FASTOPEN=y` | Eliminates one RTT on repeat connections |
| XDP/AF_XDP | `AF_XDP=y` | Zero-copy packet processing (DPDK, Suricata, Cilium) |
| BPF/eBPF | `BPF_JIT_ALWAYS_ON=y` | JIT-compiled eBPF -- XDP, security, observability |
| BPF sockmap | `SOCK_MAP=y` | Zero-copy socket redirection (Cilium, Envoy, Istio) |
| PAGE_POOL | `PAGE_POOL=y` | Per-NIC page recycling -- eliminates alloc/free per packet |
| nftables | `NF_TABLES=y` | Modern firewall backend |
| iptables | `IP_NF_IPTABLES=y` | Legacy firewall -- full compat maintained |
| CHECKSUM fix | `NETFILTER_XT_TARGET_CHECKSUM=y` | VM/container DHCP and DNS no longer silently dropped |
| Bonding/LACP | `BONDING=y` | NIC bonding and 802.3ad LACP |
| VXLAN/Geneve | `VXLAN=y` + `GENEVE=y` | Overlay networks for containers/VMs |
| MACsec | `MACSEC=y` | Layer 2 encryption for Ethernet |

---

## USB Power Management

This is a dedicated section because USB peripheral stability is one of the most common sources of silent frustration on Linux. Hyperion v2.2.1 addresses it at every layer.

### Root Cause

The Linux USB subsystem has an "autosuspend" mechanism that automatically suspends USB devices after an idle period. The kernel default prior to this release was 2 seconds. On xHCI (USB 3.x) controllers, the port power-gating behavior is more aggressive than the older EHCI spec permitted -- which is why this problem became significantly worse around kernel 5.13 when xHCI controllers became universal.

**What this causes in practice:**

| Symptom | Root cause |
|---|---|
| Dropped first keystroke after a pause in typing | Keyboard suspended after 2 s; first key triggers resume (5-50 ms latency); that keydown event is consumed by the resume handler |
| Stuck Shift/Ctrl modifier after resume | Modifier key held during suspend; keyup event delivered to the wrong device state after resume |
| USB mouse stutters after 2 seconds of no movement | Mouse suspended after 2 s idle; first movement causes resume jitter |
| USB DAC clicks/pops on audio resume | DAC enters D3cold; re-initialisation triggers a transient analog thump on the output |
| PipeWire shows "device lost" after silence | snd-usb-audio driver's idle timeout suspends the USB audio device; PipeWire loses its handle |
| ALSA xruns after a silent period | Same as above -- audio stream interrupted by device suspend/resume cycle |
| USB-Ethernet disconnect during low traffic | Network interface suspended during idle; TCP keepalives trigger reconnect storm |

### Five-Layer Defence Strategy

Hyperion implements autosuspend prevention at every layer because no single layer is sufficient on its own.

**Layer 1 -- Kernel compile-time default (this release):**

`CONFIG_USB_AUTOSUSPEND_DELAY=-1` is now set in the kernel config. Every USB device attached to any port boots with autosuspend permanently off. There is no race condition with udev. There is no initramfs ordering problem. Even if every other layer fails, this layer holds.

**Layer 2 -- Kernel boot parameter:**

Add to your bootloader cmdline:
```
usbcore.autosuspend=-1
```
This re-enforces the -1 default at runtime parameter evaluation, which happens before any driver initialises. It acts as a safety net if the Kconfig default is somehow overridden by an initramfs modprobe.d file.

Verify it took effect:
```bash
cat /sys/module/usbcore/parameters/autosuspend
# Expected: -1
```

**Layer 3 -- udev rules (required for drivers that re-enable autosuspend):**

Some drivers call `usb_autopm_enable()` in their `probe()` function to re-enable autosuspend for their specific device -- most notably the Bluetooth USB driver (`btusb`). A udev rule fires after probe and provides a post-driver guarantee:

```
# /etc/udev/rules.d/99-usb-power.rules

# Force all USB devices to stay on
ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", \
  ATTR{power/control}="on"

# Belt-and-suspenders: also set autosuspend_delay_ms to -1
ACTION=="add", SUBSYSTEM=="usb", \
  TEST=="power/autosuspend_delay_ms", \
  ATTR{power/autosuspend_delay_ms}="-1"

# HID devices (keyboards, mice, gamepads) -- class 0x03
ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="03", \
  ATTR{power/control}="on"

# USB audio (DACs, audio interfaces, headsets) -- class 0x01
ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="01", \
  ATTR{power/control}="on"

# USB hubs -- class 0x09 -- must never suspend (kills all downstream devices)
ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="09", \
  ATTR{power/control}="on"
```

**Layer 4 -- modprobe.d:**

```
# /etc/modprobe.d/usbcore.conf
options usbcore autosuspend=-1
```

This pre-configures the parameter before the module loads, which matters for initramfs-based USB early boot scenarios on dracut systems.

**Layer 5 -- sysfs runtime verification:**

```bash
# Verify the module parameter
cat /sys/module/usbcore/parameters/autosuspend
# Expected: -1

# Verify all attached USB devices
for d in /sys/bus/usb/devices/*/power/control; do
    echo "$d: $(cat $d)"
done
# All lines should show "on"

# Verify autosuspend delay for all devices
for d in /sys/bus/usb/devices/*/power/autosuspend_delay_ms; do
    echo "$d: $(cat $d)"
done
# All lines should show -1000 (ms representation of -1 seconds)
```

### Companion Files

The companion files are distributed as a separate artifact (`hyperion-companion-2.2.1.tar.gz`) attached to the GitHub release. They are **not** baked into the kernel package because:

- Policy (udev rules, sysctl) should outlive individual kernel upgrades. Install once, works across all future Hyperion versions.
- A headless server user installing Hyperion should not get `usbhid.mousepoll=1` applied silently.
- NixOS, Gentoo, and systems with declarative configuration manage these files through their own mechanisms.

The companion tarball contains:

```
hyperion-companion-2.2.1/
|-- README.md
|-- install.sh
|-- udev/
|   `-- 99-usb-power.rules
|-- modprobe/
|   |-- usbcore.conf
|   `-- snd-usb-audio.conf
`-- sysctl/
    `-- 99-hyperion.conf
```

### Verifying USB Power State

Run this after a fresh install to confirm your setup is correct:

```bash
# Check the kernel default is in effect
cat /sys/module/usbcore/parameters/autosuspend
# Must be: -1

# Check all devices are on
for d in /sys/bus/usb/devices/*/power/control; do
    val=$(cat "$d" 2>/dev/null)
    [ "$val" != "on" ] && echo "PROBLEM: $d = $val"
done
# No output = all devices are on

# Check for conflicting tools overriding the default
grep -r "autosuspend" /etc/modprobe.d/ /etc/TLP.conf /etc/tlp.d/ 2>/dev/null
# If TLP is installed and sets USB_AUTOSUSPEND=1, it will fight your config.
# Fix: set USB_AUTOSUSPEND=0 in /etc/tlp.conf
```

**Common conflict sources:**

| Tool | What it does | Fix |
|---|---|---|
| TLP | Aggressively re-enables USB autosuspend for power saving | Set `USB_AUTOSUSPEND=0` in `/etc/tlp.conf` |
| power-profiles-daemon | Can set `auto` on USB devices in balanced/powersave profile | Use `performance` profile or use udev rules to override |
| Distro modprobe.d | May ship `options usbcore autosuspend=2` | Layer 4 (modprobe.d) override fixes this |
| upower | Sometimes touches USB power policy on suspend/resume | Layer 3 (udev) fires on resume re-add events |

---

## Virtualization & Waydroid

Everything needed for full virtualisation, GPU passthrough, confidential compute, and Android container workloads is built-in and complete.

### KVM / QEMU

| Feature | Config | Notes |
|---|---|---|
| KVM Intel | `KVM_INTEL=y` | VT-x full hardware virtualisation |
| KVM AMD | `KVM_AMD=y` | AMD-V full hardware virtualisation |
| Async page fault | `KVM_ASYNC_PF=y` | vCPU parks instead of halting on host page fault -- big win for overcommit |
| Hyper-V enlightenments | `KVM_HYPERV=y` | 20-40% fewer VM exits for Windows 10/11 guests |
| SMM emulation | `KVM_SMM=y` | Required for OVMF/EDK2 UEFI firmware -- VMs were silently not booting without this |
| MMIO emulation | `KVM_MMIO=y` | ACPI/PCI ROM/BIOS emulation in VMs |
| VFIO bridge | `KVM_VFIO=y` | MSI/MSI-X from VFIO-passthrough devices reach the guest |
| Live migration | `KVM_GENERIC_DIRTYLOG_READ_PROTECT=y` | Clean dirty-log write-protect for live migration |
| Xen compat | `KVM_XEN=y` | Xen -> KVM workload migration without guest changes |
| AMD SEV | `KVM_AMD_SEV=y` | Per-VM RAM encryption (EPYC 2nd gen+) |
| AMD SEV-SNP | `KVM_AMD_SEV_SNP=y` | Secure Nested Paging -- guest memory authentication (EPYC 3rd gen+) |
| SGX in guests | `X86_SGX_KVM=y` | SGX enclaves inside KVM guests |
| 32-bit compat | `KVM_COMPAT=y` | Legacy 32-bit management tool support |

### VFIO / Device Passthrough

| Feature | Config | Notes |
|---|---|---|
| VFIO PCI | `VFIO_PCI=y` + MMAP | Core GPU/device passthrough |
| VGA aperture | `VFIO_PCI_VGA=y` | VGA legacy decode (single-GPU passthrough, Looking Glass) |
| IOMMU type 1 | `VFIO_IOMMU_TYPE1=y` | Standard IOMMU-backed VFIO |
| No-IOMMU mode | `VFIO_NOIOMMU=y` | VFIO without IOMMU -- dev/test or old hardware without VT-d |
| Platform devices | `VFIO_PLATFORM=y` | Non-PCI platform device passthrough |
| Virtual IRQ fd | `VFIO_VIRQFD=y` | Explicit eventfd-based IRQ signaling to guests |
| Mediated devices | `VFIO_MDEV=y` | Intel GVT-g, NVIDIA vGPU slicing |

### VirtIO / IOMMU

| Feature | Config | Notes |
|---|---|---|
| VirtIO MMIO | `VIRTIO_MMIO=y` | Firecracker, QEMU microvm, cloud-hypervisor, direct-boot |
| VirtIO NVDIMM | `VIRTIO_PMEM=y` | pmem DAX passthrough to guests |
| VirtIO DMA | `VIRTIO_DMA_SHARED_BUFFER=y` | Zero-copy virgl/virtio-gpu DMA |
| Para-virt IOMMU | `VIRTIO_IOMMU=y` | DMA isolation inside guests without hardware IOMMU |
| vhost vDPA | `VHOST_VDPA=y` | SR-IOV VFs exposed as VirtIO -- line-rate NIC in guest |
| DPDK/SPDK backend | `VDUSE=y` | Userspace vDPA block/net backend |
| Shared VA | `IOMMU_SVA=y` | GPU compute + VFIO + CPU share one address space |
| AMD SME/SEV | `AMD_MEM_ENCRYPT=y` | Opt-in SME/SEV host (cmdline `mem_encrypt=on`) |
| Intel TDX guest | `INTEL_TDX_GUEST=y` | Run this kernel inside an Intel TDX trust domain |

### Waydroid / Android Container

Waydroid uses LXC containers, not KVM. Every dependency is built-in and audited:

| Requirement | Config | Status |
|---|---|---|
| Binder IPC | `ANDROID_BINDER_IPC=y` | Core Android IPC mechanism |
| BinderFS | `ANDROID_BINDERFS=y` | Per-container binder device nodes at `/dev/binderfs` |
| VSOCK loopback | `VSOCK_LOOPBACK=y` | Was missing in older releases -- clipboard, ADB, and full-UI now work |
| DM user | `DM_USER=y` | Android Virtual A/B OTA snapshots |
| Netfilter checksum | `NETFILTER_XT_TARGET_CHECKSUM=y` | VM/container DHCP and DNS silent drop fixed |
| squashfs | `SQUASHFS=y` | Android system image mount |
| EROFS on-demand | `EROFS_FS_ONDEMAND=y` | Android Compressed Apex mounts |
| OverlayFS | `OVERLAY_FS=y` | Writable layer over read-only system image |
| FUSE | `FUSE_FS=y` | Some Waydroid storage paths |
| All namespaces | `UTS/IPC/PID/NET/USER_NS=y` | Full LXC isolation |
| cgroup v2 full | `CGROUPS=y` + MEMCG + BLK | Android process/memory management |
| PSI | `PSI=y` default on | Android pressure stall reporting |
| Bridge + VETH + NAT | `NET_BRIDGE` + `NF_NAT` | waydroid0 bridge with SNAT |
| TUN | `TUN=y` | Waydroid network tap |
| VSOCK + VirtIO | `VIRTIO_VSOCKETS=y` | Host to container RPC |
| evdev | `INPUT_EVDEV=y` | Input device forwarding to container |

---

## Security

Hyperion v2.2.1 ships with three LSMs compiled in simultaneously. The active LSM is selected by the distro or user via the `security=` kernel command-line parameter.

| LSM | Config | Default for | Activation |
|---|---|---|---|
| **AppArmor** | `SECURITY_APPARMOR=y` | Arch, Ubuntu, Debian | Default (no cmdline needed) |
| **SELinux** | `SECURITY_SELINUX=y` | Fedora, RHEL, CentOS, Rocky, Alma | `security=selinux` on cmdline |
| **TOMOYO** | `SECURITY_TOMOYO=y` | openSUSE | `security=tomoyo` on cmdline |
| **Landlock** | `SECURITY_LANDLOCK=y` | All | Opt-in per-process via syscall |
| **Yama** | `SECURITY_YAMA=y` | All | Ptrace scope control |
| **BPF LSM** | `BPF_LSM=y` | All | `lsm=bpf,...` on cmdline |

Additional hardening active by default:

| Feature | Config | Effect |
|---|---|---|
| Hardened usercopy | `HARDENED_USERCOPY=y` + FALLBACK=n | Detects buffer overflows at user/kernel copy boundaries |
| Kstack randomisation | `RANDOMIZE_KSTACK_OFFSET_DEFAULT=y` | Randomises kernel stack offset per syscall -- kills stack-layout exploits |
| Stack zero-init | `INIT_STACK_ALL_ZERO=y` | All stack variables zero-initialised on entry -- kills uninitialised data leaks |
| Random slab caches | `RANDOM_KMALLOC_CACHES=y` | Randomises slab cache layout -- defeats heap spray exploits |
| FORTIFY_SOURCE | `FORTIFY_SOURCE=y` | GCC compile-time buffer length checks |
| Stack protector strong | `STACKPROTECTOR_STRONG=y` | Stack canary on all functions with local arrays |
| Strict RWX | `STRICT_KERNEL_RWX=y` | Kernel text/data/BSS sections strictly non-writable/non-executable |
| ASLR entropy | `ARCH_MMAP_RND_BITS=32` | Maximum ASLR entropy on x86_64 |
| Spectre/Meltdown | `PAGE_TABLE_ISOLATION=y` + `RETPOLINE=y` | Mitigations on -- <3% gaming perf cost on modern hardware |
| IMA/EVM | `IMA=y` + `EVM=y` | Integrity measurement and extended verification |
| Intel SGX | `X86_SGX=y` | SGX enclave support -- zero overhead when unused |
| Live patch | `LIVEPATCH=y` | Apply CVE fixes without rebooting -- zero downtime security |

---

## Performance Goals

- **Scheduling latency < 1 ms** for interactive tasks under mixed workload (gaming + background compilation), enabled by `SCHED_HRTICK` + `PREEMPT` + `HIGH_RES_TIMERS` together
- **Sub-millisecond input polling** via `usbhid.mousepoll=1`, `usbhid.kbpoll=1`, `usbhid.jspoll=1` -- kernel sees physical input events within 1 ms regardless of scheduler load
- **Zero USB peripheral drops** -- autosuspend disabled at compile time, runtime, udev, and modprobe.d simultaneously
- **Runtime scheduler switching** via sched_ext -- swap between `scx_bpfland`, `scx_lavd`, `scx_rusty` without a reboot or recompile
- **NVMe throughput** within 2% of bare `none` scheduler via Kyber with tuned queue depth
- **Gaming frame pacing** improved via `PREEMPT` + `SCHED_HRTICK` + `SCHED_AUTOGROUP` + `UCLAMP` -- games pin to performance cores and get priority over background tasks
- **Network latency** reduced via BBR + FQ/CAKE + TCP Fast Open -- eliminates bufferbloat, cuts connection setup RTT by one round trip
- **Memory reclaim** non-disruptive via MGLRU with MMU-walk mode -- 16-30% reduction in stutter under memory pressure (Google/ChromeOS data)
- **Crypto throughput** maximised via AES-NI + ChaCha20-AVX + GHASH-CLMUL built-in -- full wire-speed encrypted storage and VPN from the very first syscall
- **Cache coherency** preserved via `WQ_POWER_EFFICIENT=n` -- no cross-core workqueue migration prevents L1/L2 cache thrashing
- **NUMA efficiency** via `NUMA_AWARE_SPINLOCKS=y` -- reduced lock bouncing on AMD Zen multi-CCX and multi-socket Intel
- **IRQ latency** minimised via `IRQ_FORCED_THREADING=y` -- scheduler owns all IRQ handler timing, preventing GPU/NVMe IRQ bursts from delaying audio/game frames
- **Frequency transitions** from IRQ context via `ACPI_CPPC_CPUFREQ_FAST_SWITCH=y` -- no context-switch overhead per P-state change in game loops

---

## Stability Goals

- **Zero silent OOM kills.** PSI + DAMON_RECLAIM + ZSWAP (ZSTD) catch memory pressure before the OOM killer fires. ZSWAP_SHRINKER evicts cold compressed pages back to disk before the pool saturates.
- **No phantom reboots.** Soft lockup, hard lockup, and hung task detectors are always active. Hung task timeout is 120 seconds -- catches real stalls without false-positiving under load.
- **Correct module loading.** `CONFIG_MODVERSIONS` ensures ABI mismatches are caught at `insmod` with a clear error, not discovered when a driver silently does nothing.
- **Thermal safety.** Power allocator thermal governor prevents cliff-edge throttle. `SENSORS_CORETEMP`, `K10TEMP`, and `AMD_ENERGY` always loaded. Fan control via `NCT6775` and `IT87`.
- **Crash visibility.** `pstore` + RAM backend logs kernel panics and oopses across reboots -- you will always know why a machine died.
- **No boot surprises.** All critical boot drivers (`VIRTIO_BLK`, `ATA_PIIX`, `SATA_AHCI`, `USB_HID`, `EFIVAR_FS`) are built-in, not modules. Module-load timing cannot cause a kernel panic or empty rootfs.
- **USB peripheral reliability.** `USB_AUTOSUSPEND_DELAY=-1` + `USB_DEFAULT_PERSIST=y` + five-layer defence strategy ensures no USB device goes to sleep unexpectedly, and all devices survive system sleep/wake with their state intact.
- **Zero-downtime security.** `LIVEPATCH=y` allows CVE patches to be applied to a running kernel without interrupting active workloads.

---

## Power Management

| Feature | Config | Effect |
|---|---|---|
| AMD P-State Active | `X86_AMD_PSTATE_DEFAULT_MODE=3` | Hardware EPP -- best Zen3/4 single-core boost |
| AMD PMF | `AMD_PMF=y` | SmartShift and platform profiles for Zen 4+ laptops (Rembrandt, Phoenix, Hawk Point) |
| Intel P-State + HWP | `X86_INTEL_PSTATE=y` + `X86_HWP=y` | Hardware-managed boost, less software scheduling overhead |
| CPPC fast switch | `ACPI_CPPC_CPUFREQ_FAST_SWITCH=y` | Frequency transitions from IRQ context -- no context-switch overhead |
| AMD PMC | `AMD_PMC=y` | Ryzen laptop s2idle (modern standby) -- no battery drain on suspend |
| AMD HSMP | `AMD_HSMP=y` | Per-CCX power limits and Infinity Fabric telemetry on EPYC/Threadripper |
| Intel RAPL | `INTEL_RAPL=y` | CPU/DRAM power telemetry from MSRs -- powers `turbostat`, EAS |
| AMD Energy | `AMD_ENERGY=y` | Equivalent AMD CPU power readout |
| Platform profile | `ACPI_PLATFORM_PROFILE=y` | `power-profiles-daemon` power slider in GNOME/KDE works |
| CPU idle TEO | `CPU_IDLE_GOV_TEO=y` | Best C-state selection -- ~15% less wake latency vs MENU |
| Intel idle | `INTEL_IDLE=y` | Native Intel C6/C8/C10 deep sleep states |
| Halt poll | `HALTPOLL_CPUIDLE=y` | Spin-poll before sleeping -- win for high-frequency task switches |
| Thermal pressure | `THERMAL_PRESSURE=y` | Thermal load feedback into EAS scheduler decisions |
| USB autosuspend off | `USB_AUTOSUSPEND_DELAY=-1` | All USB devices stay powered -- see USB Power Management section |
| USB device persist | `USB_DEFAULT_PERSIST=y` | USB device state survives system sleep/wake |
| Runtime PM | `PM_RUNTIME=y` | Per-device runtime suspend for non-USB devices (GPU D3cold, NVMe APST) |
| Energy model | `ENERGY_MODEL=y` | EAS energy-aware scheduling for heterogeneous CPUs |

**Important note on USB and PM_RUNTIME:** `PM_RUNTIME=y` is kept enabled because it is mandatory infrastructure for GPU D3cold states, NVMe APST, and PCIe link power management. Disabling it globally to solve the USB autosuspend problem would break GPU power management and NVMe performance. The correct approach -- taken here -- is to set the USB autosuspend default to -1 while leaving PM_RUNTIME enabled for all other subsystems.

---

## Module & DKMS Compatibility

Hyperion treats module compatibility as a **first-class feature**, not an afterthought.

**What this means in practice:**
- Kernel headers installed to `/usr/src/linux-headers-6.19.6-Hyperion-2.2.1/`
- Build symlink `/lib/modules/6.19.6-Hyperion-2.2.1/build` always points to the correct headers directory
- `CONFIG_IKHEADERS=y` makes headers available at `/sys/kernel/kheaders.tar.xz` as a runtime fallback for any DKMS module that needs them
- `CONFIG_IKCONFIG=y` + `CONFIG_IKCONFIG_PROC=y` -- running config always readable at `/proc/config.gz`
- `CONFIG_MODVERSIONS=y` -- every exported symbol carries a CRC checksum; mismatched modules are rejected cleanly at `insmod` with a clear error, not a kernel panic
- `CONFIG_MODULE_SRCVERSION_ALL=y` -- embeds a srcversion hash in every module for exact traceability
- Module signing is **off by default** to avoid blocking DKMS workflows -- enable `CONFIG_MODULE_SIG=y` on Secure Boot systems

**DKMS modules known to work:**

| Module | Version | Notes |
|---|---|---|
| NVIDIA proprietary | 550.x+ | Install `nvidia-dkms` from your distro -- standard path |
| VirtualBox kernel | 7.x | VirtualBox Extension Pack works |
| ZFS on Linux | 2.x | All ZFS pool features supported |
| v4l2loopback | 0.12.x+ | Virtual video devices for OBS, streaming |
| ACPI call | any | Thinkpad battery thresholds, fan control |
| tp-smapi | any | ThinkPad hardware SMAPI access |
| OpenRGB | any | Uses `HIDRAW` -- built-in |

---

## Distro Compatibility

Hyperion v2.2.1 is designed and tested for distribution-agnostic deployment. A single `bzImage` + `initramfs` pair boots and operates correctly on every mainstream Linux distribution.

| Distribution | Status | LSM Active | Package Manager |
|---|---|---|---|
| **Arch Linux** | Primary target | AppArmor | pacman / AUR |
| **Ubuntu 24.04 LTS** | Full support | AppArmor | apt / snap |
| **Debian 12** | Full support | AppArmor | apt |
| **Linux Mint 22** | Full support | AppArmor | apt |
| **Fedora 41** | Full support | SELinux | dnf |
| **RHEL 9 / AlmaLinux 9 / Rocky 9** | Full support | SELinux | dnf |
| **openSUSE Tumbleweed** | Full support | AppArmor / TOMOYO | zypper |
| **openSUSE Leap 15** | Full support | AppArmor | zypper |
| **Manjaro** | Full support | AppArmor | pacman |
| **Pop!_OS 22.04** | Full support | AppArmor | apt |
| **EndeavourOS** | Full support | AppArmor | pacman |
| **Gentoo** | Full support | AppArmor | emerge |
| **NixOS** | Full support | AppArmor | nix |

**How multi-LSM compatibility works:** All three LSMs (AppArmor, SELinux, TOMOYO) are compiled into the single kernel binary. The distro selects the active LSM via `security=<name>` on the kernel command line. Without that parameter, AppArmor activates by default. Fedora/RHEL installations that set `security=selinux` get full SELinux -- all compiled-in policy hooks are available.

**USB power management and distro interaction:** On Ubuntu, Fedora, Manjaro, and Pop!_OS, TLP or power-profiles-daemon is almost certainly installed and will override the kernel's USB autosuspend default. The [companion files](#companion-files-installation) are required on these distributions to prevent that override. On a minimal Arch or Gentoo install without TLP, the kernel default alone is sufficient.

---

## Supported Architectures

| Architecture | Status | Notes |
|---|---|---|
| `x86_64` | **Fully supported** | Primary target -- fully optimised, all chipsets |
| `i686` | Not supported | 32-bit dropped |
| `aarch64` | Not planned | Would require a separate config pass |

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
# Debian / Ubuntu / Linux Mint
sudo apt install -y build-essential libncurses-dev bison flex libssl-dev \
  libelf-dev dwarves bc pahole git make gcc dkms

# Fedora / RHEL / CentOS
sudo dnf install -y gcc make bison flex elfutils-libelf-devel \
  openssl-devel ncurses-devel bc dkms git pahole

# Arch Linux / Manjaro / EndeavourOS
sudo pacman -S --needed base-devel xmlto kmod inetutils bc libelf \
  pahole cpio perl tar xz dkms git

# openSUSE
sudo zypper install -y -t pattern devel_basis
sudo zypper install -y ncurses-devel openssl-devel bc dkms pahole

# Gentoo
emerge --ask sys-devel/bc dev-util/pahole sys-apps/kmod
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

# 4. Optional: review or customise
make menuconfig

# 5. Build (use all cores)
make -j$(nproc) LOCALVERSION="-Hyperion-2.2.1"

# 6. Build modules (DKMS infrastructure)
make modules -j$(nproc)

# 7. Install modules
sudo make modules_install

# 8. Install headers (required for DKMS)
sudo bash /path/to/hyperion/scripts/install-headers.sh

# 9. Install kernel
sudo make install

# 10. Update bootloader
sudo update-grub                                       # Debian/Ubuntu
sudo grub2-mkconfig -o /boot/grub2/grub.cfg           # Fedora/RHEL
sudo grub-mkconfig -o /boot/grub/grub.cfg              # Arch
sudo grub2-mkconfig -o /boot/grub2/grub.cfg            # openSUSE
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
# Expected: 6.19.6-Hyperion-2.2.1

uname -v
# Expected: #1 SMP PREEMPT Linux 6.19.6-Hyperion-2.2.1 (Soumalya Das) 2026

# Verify headers symlink
ls -la /lib/modules/$(uname -r)/build
# Should point to /usr/src/linux-headers-6.19.6-Hyperion-2.2.1

# Verify IKCONFIG (running config)
zcat /proc/config.gz | grep "CONFIG_USB_AUTOSUSPEND_DELAY"
# Expected: CONFIG_USB_AUTOSUSPEND_DELAY=-1

# Verify USB autosuspend is off
cat /sys/module/usbcore/parameters/autosuspend
# Expected: -1

# Test DKMS
sudo dkms status

# Verify Wi-Fi chipset loaded
ip link show
lspci -k | grep -A3 -i "network"

# Verify Thunderbolt (if applicable)
ls /sys/bus/thunderbolt/devices/

# Verify V4L2 webcam
ls /dev/video*
v4l2-ctl --list-devices

# Verify audio
aplay -l
pactl list sinks
```

### Generate initramfs

Before booting the kernel, generate the initramfs. With all drivers built-in, the initramfs can be minimal (only needs `udev`, `base` hooks):

```bash
# mkinitcpio (Arch)
sudo mkinitcpio -k 6.19.6-Hyperion-2.2.1 \
  -g /boot/initramfs-6.19.6-Hyperion-2.2.1.img

# Or use the provided script
chmod +x ./scripts/generate-initramfs.sh
sudo ./scripts/generate-initramfs.sh

# dracut (Fedora/RHEL/openSUSE)
sudo dracut --force /boot/initramfs-6.19.6-Hyperion-2.2.1.img \
  6.19.6-Hyperion-2.2.1

# initramfs-tools (Debian/Ubuntu)
sudo update-initramfs -c -k 6.19.6-Hyperion-2.2.1
```

### Installing a DKMS Module (example: v4l2loopback)

```bash
# Debian/Ubuntu
sudo apt install v4l2loopback-dkms

# Arch
yay -S v4l2loopback-dkms

# Verify
sudo dkms status
# v4l2loopback/0.12.x, 6.19.6-Hyperion-2.2.1, x86_64: installed
```

### SELinux Setup (Fedora/RHEL users)

Hyperion ships SELinux compiled in. On a Fedora/RHEL install, the distro bootloader already passes `security=selinux` -- no manual steps needed. On a fresh Hyperion install where you want SELinux:

```bash
# Add to your bootloader config (GRUB example)
# GRUB_CMDLINE_LINUX="security=selinux selinux=1 enforcing=0"
# enforcing=0 = permissive mode (log but don't block) for initial setup

# Relabel filesystem on first boot
sudo fixfiles onboot
sudo reboot
```

---

## Companion Files Installation

The companion files fix USB peripheral stability on distros with TLP or power-profiles-daemon, and configure sysctl for optimal network and memory performance. They are distributed as a separate release artifact to avoid baking policy into the kernel package.

### Download and Install

```bash
# Download the companion tarball from the GitHub release
wget https://github.com/pro-grammer-SD/hyperion/releases/download/v2.2.1/hyperion-companion-2.2.1.tar.gz

# Extract
tar -xzf hyperion-companion-2.2.1.tar.gz
cd hyperion-companion-2.2.1

# Install all files and reload rules
sudo bash install.sh
```

The install script places the following files:

| File | Destination | Purpose |
|---|---|---|
| `udev/99-usb-power.rules` | `/etc/udev/rules.d/` | Forces `power/control=on` for all USB devices at add time. Class-based rules for HID, audio, and hub classes. |
| `modprobe/usbcore.conf` | `/etc/modprobe.d/` | `options usbcore autosuspend=-1` -- pre-configures the parameter before the module loads. |
| `modprobe/snd-usb-audio.conf` | `/etc/modprobe.d/` | `options snd-usb-audio implicit_fb=1 ignore_ctl_error=1` -- fixes async USB DAC dropout. |
| `sysctl/99-hyperion.conf` | `/etc/sysctl.d/` | vm.swappiness, vm.dirty_ratio, tcp_rmem/wmem, net.core.default_qdisc=fq, numa_balancing. |

### Manual Installation (if preferred)

```bash
# Layer 3: udev rules
sudo tee /etc/udev/rules.d/99-usb-power.rules << 'EOF'
ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", \
  ATTR{power/control}="on"
ACTION=="add", SUBSYSTEM=="usb", \
  TEST=="power/autosuspend_delay_ms", \
  ATTR{power/autosuspend_delay_ms}="-1"
ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="03", \
  ATTR{power/control}="on"
ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="01", \
  ATTR{power/control}="on"
ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="09", \
  ATTR{power/control}="on"
EOF

# Layer 4: modprobe.d
echo "options usbcore autosuspend=-1" | \
  sudo tee /etc/modprobe.d/usbcore.conf

echo "options snd-usb-audio implicit_fb=1 ignore_ctl_error=1" | \
  sudo tee /etc/modprobe.d/snd-usb-audio.conf

# Reload without reboot
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=usb
```

---

## Recommended Boot Parameters

Add these to `GRUB_CMDLINE_LINUX` in `/etc/default/grub`, or to your systemd-boot entry.

### AMD (Zen3/4 Desktop)

```
quiet splash
preempt=full threadirqs
usbcore.autosuspend=-1 usbcore.use_persist=1
usbhid.mousepoll=1 usbhid.kbpoll=1 usbhid.jspoll=1
amd_pstate=active amd_iommu=pt
transparent_hugepage=madvise hugepagesz=2M hugepages=512
nohz_full=1-N rcu_nocbs=1-N skew_tick=1 nosoftlockup
lsm=landlock,lockdown,yama,apparmor,bpf
```

### Intel (12th/13th/14th gen Desktop)

```
quiet splash
preempt=full threadirqs
usbcore.autosuspend=-1 usbcore.use_persist=1
usbhid.mousepoll=1 usbhid.kbpoll=1 usbhid.jspoll=1
intel_pstate=active
transparent_hugepage=madvise hugepagesz=2M hugepages=512
nohz_full=1-N rcu_nocbs=1-N skew_tick=1 nosoftlockup
lsm=landlock,lockdown,yama,apparmor,bpf
```

Replace `N` with your last CPU index (`nproc --all` minus 1).

### Parameter Reference

| Parameter | Why |
|---|---|
| `preempt=full` | Maximum scheduler responsiveness. CFS preempts at every opportunity -- lowest input latency for Wayland/Hyprland. |
| `threadirqs` | All IRQ handlers become kernel threads. GPU interrupt storms no longer block keyboard/mouse event delivery. |
| `usbcore.autosuspend=-1` | Runtime redundancy for the kernel compile-time default. Catches initramfs modprobe.d override scenarios. |
| `usbcore.use_persist=1` | USB device logical state preserved across suspend -- keyboard LEDs and audio sample rates survive sleep/wake. |
| `usbhid.mousepoll=1` | Forces 1 ms (1000 Hz) USB mouse polling. Default 8 ms (125 Hz) introduces up to 8 ms of input lag before scheduling even enters the picture. |
| `usbhid.kbpoll=1` | Forces 1 ms keyboard polling. Eliminates dropped keystrokes under heavy CPU load where the default 10 ms poll misses events. |
| `usbhid.jspoll=1` | Forces 1 ms gamepad polling. At 8 ms default, a single-frame input window at 60 FPS (16 ms) is already half consumed at poll time. |
| `amd_pstate=active` | AMD CPU hardware manages its own boost frequency within the EPP hint. Faster single-core ramp-up than OS-controlled passive mode. |
| `transparent_hugepage=madvise` | THP only for memory regions that explicitly request it. Games and JVMs benefit; background daemons do not waste 2 MB chunks on small allocations. |
| `nohz_full=1-N` | Tickless operation on all CPUs except core 0. A game loop or ML inference thread receives zero timer interrupts -- eliminating 1 ms periodic jitter. |
| `skew_tick=1` | Staggers the HZ tick across CPUs -- eliminates thundering-herd IRQ storms where all CPUs fire simultaneously. |
| `nosoftlockup` | Disables the soft lockup watchdog. On nohz_full CPUs it fires false positives during legitimate tight game loops. |

---

## Development Workflow

```
+------------------------------------------------------------------+
|                    Hyperion Dev Workflow                          |
+--------------+--------------+--------------+--------------------+
|  1. Patch    |  2. Config   |  3. Build    |  4. Test           |
|              |              |              |                    |
| patches/     | hyperion.    | scripts/     | CI pipeline        |
| *.patch      | config       | build-       | .github/           |
|              |              | kernel.sh    | workflows/         |
+--------------+--------------+--------------+--------------------+
```

1. **Add a patch:** Place `*.patch` files in `patches/` -- the build script applies them in sorted order via `git apply`
2. **Modify config:** Edit `hyperion.config` directly. Every change must include a comment with a source reference (LKML link, kernel.org doc, or Phoronix benchmark)
3. **Build:** Run `scripts/build-kernel.sh`
4. **Test:** CI auto-builds on every push and PR -- see `.github/workflows/build.yml`. CI also performs a QEMU boot test with the built `bzImage`
5. **Document:** Add notes to `docs/` for anything non-obvious. Config additions should also appear in the release notes template

See [CONTRIBUTING.md](CONTRIBUTING.md) for full contribution guidelines.

---

## Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md) for the full guide.

### Quick Diagnosis

```bash
# Check if kernel is running
uname -r
# Expected: 6.19.6-Hyperion-2.2.1

# Check USB autosuspend is off
cat /sys/module/usbcore/parameters/autosuspend
# Expected: -1

# Check all USB devices are on
for d in /sys/bus/usb/devices/*/power/control; do
    val=$(cat "$d" 2>/dev/null)
    echo "$d: $val"
done
# All should show "on"

# Check if headers are present
ls /usr/src/linux-headers-$(uname -r)/

# Check build symlink
readlink /lib/modules/$(uname -r)/build

# Re-install headers if missing
sudo bash scripts/install-headers.sh

# Force DKMS rebuild after headers reinstall
sudo dkms autoinstall -k $(uname -r)

# Check dmesg for any driver or module errors
dmesg | grep -E "(module|DKMS|ERROR|WARN|failed)" | tail -40

# Check Wi-Fi driver loaded correctly
dmesg | grep -i "ath\|iwl\|rtw\|mt76\|brcm" | tail -20

# Check audio subsystem
dmesg | grep -i "sof\|acp\|hda\|codec" | tail -20

# Check for Waydroid/Binder issues
dmesg | grep -i "binder\|waydroid\|android" | tail -20

# PSI -- check if system is under memory/CPU/IO pressure
cat /proc/pressure/memory
cat /proc/pressure/cpu
cat /proc/pressure/io
```

### Common Issues

**Arch ISO fails to boot with "losetup: failed to set up loop device":**
```bash
# This means CONFIG_BLK_DEV_LOOP was not built into the kernel.
# Verify it is present and built-in (=y, not =m):
zcat /proc/config.gz | grep BLK_DEV_LOOP
# Expected:
#   CONFIG_BLK_DEV_LOOP=y
#   CONFIG_BLK_DEV_LOOP_MIN_COUNT=8

# If you see =m, the module may not be in your initramfs.
# Rebuild the kernel with BLK_DEV_LOOP=y (built-in).
# Hyperion v2.2.1+ has this set correctly.

# To verify loop devices exist at runtime:
ls /dev/loop*
# You should see /dev/loop0 through /dev/loop7
losetup --list
```

**Arch ISO squashfs root fails to mount after loop device succeeds:**
```bash
# Verify squashfs support and decompression algorithms:
zcat /proc/config.gz | grep -E "SQUASHFS|OVERLAY"
# Expected:
#   CONFIG_SQUASHFS=y
#   CONFIG_SQUASHFS_XZ=y
#   CONFIG_SQUASHFS_ZSTD=y
#   CONFIG_OVERLAY_FS=y

# If OVERLAY_FS=m (module), ensure it is in the initramfs.
# Hyperion builds it as =y (built-in).
```

**USB keyboard drops keystrokes or first keypress is lost:**
```bash
# Check if autosuspend is in effect
cat /sys/module/usbcore/parameters/autosuspend
# If not -1, TLP or another tool is overriding it
grep -r "autosuspend" /etc/modprobe.d/ /etc/tlp.conf /etc/tlp.d/ 2>/dev/null

# Install companion files if not already done
# Then verify
for d in /sys/bus/usb/devices/*/power/control; do cat "$d"; done
# All should show "on"
```

**USB DAC clicks, pops, or disconnects from PipeWire:**
```bash
# Check if the DAC is autosuspending
cat /sys/bus/usb/devices/*/power/control
# Find your DAC's entry -- if "auto", the udev rule hasn't fired

# Add snd-usb-audio options
echo "options snd-usb-audio implicit_fb=1 ignore_ctl_error=1" | \
  sudo tee /etc/modprobe.d/snd-usb-audio.conf
sudo modprobe -r snd-usb-audio && sudo modprobe snd-usb-audio
```

**DKMS module fails to build:**
```bash
# Ensure headers are in the right place
ls /lib/modules/$(uname -r)/build
# If symlink is broken:
sudo bash scripts/install-headers.sh
```

**No Wi-Fi on first boot:**
```bash
# Check which chipset you have and if the driver loaded
lspci -k | grep -A3 -i "network\|wireless"
dmesg | grep -i "firmware\|ath\|iwl\|rtw\|mt76"
# Qualcomm/Realtek Wi-Fi requires firmware blobs from linux-firmware
# Install: sudo apt install firmware-linux       (Debian)
#          sudo pacman -S linux-firmware          (Arch)
```

**Laptop audio silent:**
```bash
# Check which SoC audio driver loaded
dmesg | grep -i "sof\|acp\|codec\|rt5682\|cs35l41"
# If SOF firmware missing:
# sudo apt install firmware-sof-signed  (Ubuntu/Debian)
# sudo pacman -S sof-firmware           (Arch)
```

**Waydroid clipboard or ADB not working:**
```bash
# Verify VSOCK loopback is present
zcat /proc/config.gz | grep VSOCK_LOOPBACK
# Should return: CONFIG_VSOCK_LOOPBACK=y
# Restart Waydroid session
sudo waydroid session stop && sudo waydroid session start
```

**SELinux blocking services on Fedora:**
```bash
# Check SELinux denials
sudo ausearch -m avc -ts recent | audit2why
# Set permissive temporarily
sudo setenforce 0
```

**TLP re-enabling USB autosuspend:**
```bash
# Check TLP config
grep USB_AUTOSUSPEND /etc/tlp.conf
# If USB_AUTOSUSPEND=1, change it to:
# USB_AUTOSUSPEND=0
# Then reload:
sudo tlp start
```

---

## Credits

| Role | Name |
|---|---|
| **Linux Kernel Developer** | **Soumalya Das** |
| Base Kernel | Linus Torvalds & the Linux kernel community |
| Config inspiration | CachyOS, XanMod, Nobara Project, Liquorix, Arch, Fedora, Ubuntu |
| IO scheduler research | Paolo Valente (BFQ), Google (BBR, TCP BBRv3) |
| Memory management | MGLRU: Yu Zhao (Google); DAMON: SeongJae Park (Amazon) |
| sched_ext / BPF schedulers | sched-ext/scx project, CachyOS team |
| SCHED_HRTICK / preemption | Ingo Molnar, Peter Zijlstra, Thomas Gleixner |
| PREEMPT_LAZY | Peter Zijlstra, Thomas Gleixner (merged Linux 6.12) |
| THP vmemmap optimization | Muchun Song (ByteDance) |
| USB autosuspend analysis | Sarah Sharp (Intel xHCI maintainer), Alan Stern (USB persist) |
| Live kernel patching | Josh Poimboeuf (Red Hat), SUSE kGraft team |
| Dynamic probes | Masami Hiramatsu (KPROBES), Srikar Dronamraju (UPROBES) |
| BPF sockmap | John Fastabend, Daniel Borkmann (Cilium/kernel.org) |
| AMD Platform Management | AMD Open Source driver team (P-State, PMC, PMF, HSMP, Energy) |
| Intel power management | Intel Open Source Technology Center (P-State, SOF, RAPL) |
| SoC audio (SOF) | Pierre-Louis Bossart & Intel SOF team |
| Thermal management | Intel Open Source Technology Center |
| Security hardening | Kees Cook (kstack randomisation, hardened usercopy, FORTIFY_SOURCE) |
| SELinux | NSA, Tresys Technology, Red Hat SELinux team |
| Wi-Fi drivers | Qualcomm Atheros ath team, Realtek RTW team, Intel IWL team |
| Thunderbolt/USB4 | Intel Thunderbolt driver team, Mika Westerberg |
| Virtualization | RHEL/KVM perf guide, QEMU/KVM upstream, Red Hat KVM team |
| WireGuard | Jason Donenfeld (zx2c4) |
| BLAKE2 crypto | Samuel Neves, Jean-Philippe Aumasson |
| PAGE_POOL | Jesper Dangaard Brouer, Ilias Apalodimas |
| CPPC fast switch | Viresh Kumar |
| Performance research | Phoronix, LKML, r/linux_gaming, XDA, ChromeOS/Android kernel teams |

---

## License

Hyperion Kernel configuration, scripts, and documentation are released under the [MIT License](LICENSE).

The Linux kernel itself is licensed under **GPL-2.0-only** as required by Linus Torvalds and the kernel community. This project does not modify the kernel license.

---

<div align="center">

*Built with precision. Tuned for humans. Named after a Titan.*

**Hyperion Kernel v2.2.1** - Soumalya Das - 2026

</div>
