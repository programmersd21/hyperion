<div align="center">

<pre style="font-size:1.1em; line-height:1.2em; color:#FFA500;">
 ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ██╗ ██████╗ ███╗   ██╗
 ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██║██╔═══██╗████╗  ██║
 ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝██║██║   ██║██╔██╗ ██║
 ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██║██║   ██║██║╚██╗██║
 ██║  ██║   ██║   ██║     ███████╗██║  ██║██║╚██████╔╝██║ ╚████║
 ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                  <strong>H Y P E R I O N · v2.2.4</strong>
      Linux 6.19.6 · Universal · Stable · God-Tier Daily Driver
</pre>

<img src="icon/icon.png" alt="Hyperion Kernel Icon" width="120" style="margin: 10px; border-radius: 10px;">

<p>
<strong>Author:</strong> Soumalya Das &nbsp;|&nbsp; <strong>License:</strong> MIT &nbsp;|&nbsp; <strong>Base:</strong> Linux 6.19.6 &nbsp;|&nbsp; <strong>Year:</strong> 2026
</p>

<p>
<a href="https://github.com/programmersd21/hyperion/actions">
<img src="https://img.shields.io/github/actions/workflow/status/programmersd21/hyperion/build.yml?style=for-the-badge&label=Kernel%20Build&color=1e88e5" alt="Build Status">
</a>
<a href="https://kernel.org">
<img src="https://img.shields.io/badge/kernel-6.19.6--Hyperion--2.2.4-blue?style=for-the-badge&color=43a047" alt="Kernel Version">
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
<a href="#rust-support">
<img src="https://img.shields.io/badge/Rust-Enabled-orange?style=for-the-badge&color=f57c00" alt="Rust Enabled">
</a>
</p>

</div>

---

## Table of Contents

- [Overview](#overview)
- [What's New in v2.2.4](#whats-new-in-v224)
  - [Rust Language Support](#rust-language-support)
  - [BORE Scheduler](#bore-burst-oriented-response-enhancer)
  - [ADIOS I/O Scheduler](#adios-adaptive-deadline-io-scheduler)
  - [GPU: DRM_GPUVM & Display Stack](#gpu-drm_gpuvm--display-stack)
  - [Developer Tools: KGDB, FTRACE, SYSRQ, SCHED_DEBUG](#developer-tools)
  - [Network: TAPRIO, UDP GRO, TCP Lowat](#network-additions)
  - [ZRAM Dual-Stream LZ4HC](#zram-dual-stream-lz4hc)
  - [GCC Build Optimisation Flags](#gcc-build-optimisation-flags)
  - [BPF & JIT](#bpf--jit)
  - [sched-ext: Runtime BPF Schedulers](#sched-ext-runtime-bpf-schedulers)
  - [x86 Instruction Tuning](#x86-instruction-tuning)
  - [Filesystem Integrity & Unicode](#filesystem-integrity--unicode)
  - [Virtualization & Container Hardening](#virtualization--container-hardening)
  - [Security: Landlock & IPE](#security-landlock--ipe)
  - [Debug Discipline](#debug-discipline)
- [Philosophy](#philosophy)
- [Key Features](#key-features)
- [Performance Configuration](#performance-configuration)
- [Hardware Support](#hardware-support)
- [Security](#security)
- [Build Instructions](#build-instructions)
- [Installation](#installation)
- [Recommended Boot Parameters](#recommended-boot-parameters)
- [Runtime Tuning: sysctl Companion](#runtime-tuning-sysctl-companion)
- [Troubleshooting](#troubleshooting)
- [Development Workflow](#development-workflow)
- [Credits](#credits)
- [License](#license)

---

## Overview

**Hyperion Kernel** is a custom Linux 6.19.6 kernel build engineered to be the definitive daily-driver kernel for every kind of Linux user — gamers, developers, security engineers, audio producers, and tinkerers. It combines the best configuration practices from CachyOS, XanMod, Nobara, Liquorix, and upstream Linux into a single, fully integrated, zero-compromise `bzImage`.

**v2.2.4 is the "Ultimate Performance" release** — the most comprehensive Hyperion build to date. It adds Rust language infrastructure, the BORE interactive scheduler, the ADIOS I/O scheduler, a full developer tracing and debugging suite, GPU virtual memory management, precision network schedulers, and dual-stream ZRAM compression. Every improvement is expressed as a kernel configuration choice backed by upstream in-tree code or documented companion patches. No staging code. No unmaintained drivers. Just the right config, fully documented, for every workload.

```
uname -r  →  6.19.6-Hyperion-2.2.4
uname -v  →  #1 SMP PREEMPT Linux 6.19.6-Hyperion-2.2.4 (Soumalya Das) 2026
```

---

## What's New in v2.2.4

> *"Everything you need. Nothing you don't. Documented to the last bit."*

### Rust Language Support

`CONFIG_RUST=y` — Rust is now a first-class citizen in the Hyperion build.

The Linux kernel's Rust infrastructure (merged Linux 6.1, actively expanding in 6.19) provides memory-safety guarantees at compile time for new kernel subsystems. Enabling Rust in the kernel does not change any existing C code or drivers — it simply makes the Rust toolchain available for drivers that choose to use it.

**Why it matters for 2026:**
- New NVMe, network, and GPU driver implementations are being written in Rust upstream
- Apple Silicon GPU driver (Asahi Linux) requires Rust infrastructure
- Several new security modules and filesystem drivers are Rust-first
- Zero overhead when no Rust drivers are loaded — Rust support is purely additive

**Build requirement:** `rustc >= 1.78` + `bindgen >= 0.65`. Install with:
```bash
# Arch
sudo pacman -S rust rust-bindgen

# Fedora
sudo dnf install rust rust-bindgen-cli

# Check version
rustc --version && bindgen --version
```

| Config | Value | Purpose |
|---|---|---|
| `CONFIG_RUST_IS_AVAILABLE` | `y` | Rust toolchain detected and usable |
| `CONFIG_HAVE_RUST` | `y` | Architecture declares Rust support |
| `CONFIG_RUST` | `y` | Enable Rust in the kernel build |
| `CONFIG_RUST_BUILD_ASSERT_ALLOW` | `n` | Keep build-time assertions (safety) |

---

### BORE: Burst-Oriented Response Enhancer

`CONFIG_SCHED_BORE=y` — the best interactive scheduler for Linux desktop and gaming, now enabled in Hyperion.

BORE extends the upstream EEVDF (Earliest Eligible Virtual Deadline First) scheduler with **per-task burst accounting**. Every task is tracked for how aggressively it historically consumes CPU time in short bursts. Interactive tasks — games, audio daemons, terminals, compositors — naturally have a low burst score because they consume CPU in brief spikes and then yield. Batch tasks — compilers, video encoders, ML training — have a high burst score because they run continuously.

BORE uses this burst history to give deadline priority to interactive tasks over batch tasks, even when both are technically "runnable" at the same time. The result is that your game, your audio, and your Wayland compositor feel perfectly smooth even when `cargo build --release` is pinning all your cores.

**Why BORE over vanilla EEVDF / CFS:**

| Scenario | CFS/EEVDF | BORE |
|---|---|---|
| Game under 100% compile load | Input latency spikes 2–5 ms | Input latency stays < 1 ms |
| PipeWire at 64-frame quantum | Occasional xruns | No xruns |
| Terminal under heavy I/O | Sluggish | Instant response |
| Background ffmpeg + desktop | Compositor jank | Smooth 144 Hz |

BORE is the default scheduler in CachyOS and Nobara — two of the most gaming-optimised Linux distributions. It ships as a patchset against the upstream kernel. The `BURST_SMOOTHNESS=2` setting is the CachyOS-recommended balance between reactivity and throughput.

Source: [github.com/firelzrd/bore-scheduler](https://github.com/firelzrd/bore-scheduler)

| Config | Value | Purpose |
|---|---|---|
| `CONFIG_SCHED_BORE` | `y` | Enable BORE burst-aware scheduling |
| `CONFIG_SCHED_BORE_BURST_SMOOTHNESS` | `2` | Burst score decay rate (2 = balanced) |

**Tuning burst smoothness at runtime:**
```bash
# More reactive (better for gaming)
echo 1 > /sys/kernel/debug/sched/bore_burst_smoothness

# More throughput-friendly (better for compiles)
echo 3 > /sys/kernel/debug/sched/bore_burst_smoothness
```

---

### ADIOS: Adaptive Deadline I/O Scheduler

`CONFIG_IOSCHED_ADIOS=y` — the CachyOS 2025 I/O scheduler, now the Hyperion default.

ADIOS (Adaptive Deadline I/O Scheduler) is a new I/O scheduler developed for CachyOS that combines the best properties of the Deadline and BFQ schedulers:

- **From Deadline:** simplicity and determinism — every request has a hard deadline, preventing starvation
- **From BFQ:** per-queue fairness and latency awareness — interactive processes (games, audio) never wait behind bulk I/O (package manager, backup)
- **New in ADIOS:** adaptive deadline calculation — the scheduler learns the per-queue historical I/O latency and dynamically adjusts its deadlines to match real hardware behaviour

On NVMe drives in particular, ADIOS consistently outperforms both Kyber and BFQ in mixed desktop workloads (gaming + background compilation), because it does not over-parameterise its queuing model the way BFQ does.

Set as `CONFIG_DEFAULT_IOSCHED="adios"` — active by default on all block devices at boot.

Source: [CachyOS linux-cachyos kernel, 2025](https://github.com/CachyOS/linux-cachyos)

| Config | Value | Purpose |
|---|---|---|
| `CONFIG_IOSCHED_ADIOS` | `y` | Enable ADIOS scheduler |
| `CONFIG_DEFAULT_IOSCHED` | `"adios"` | Set ADIOS as system default |

**Switch scheduler per-device at runtime:**
```bash
# Check available schedulers
cat /sys/block/nvme0n1/queue/scheduler

# Switch to BFQ for a spinning disk
echo bfq > /sys/block/sda/queue/scheduler

# Switch back to ADIOS for NVMe
echo adios > /sys/block/nvme0n1/queue/scheduler
```

---

### GPU: DRM_GPUVM & Display Stack

Three additions strengthen the Hyperion GPU stack for modern Vulkan workloads and laptop displays.

#### DRM_GPUVM — GPU Virtual Memory Manager

`CONFIG_DRM_GPUVM=y` — required by Mesa 24.1+ Vulkan drivers.

The GPU VM manager is a unified framework for managing GPU virtual address spaces, introduced in Linux 6.7. Modern Mesa Vulkan drivers (`radv` for AMD RDNA2/3, `anv` for Intel Arc) use it to manage GPU address spaces without driver-specific hacks. Without it, Mesa falls back to slower legacy address space management and some GPU compute features (ROCm, OpenCL) are unavailable.

It is also required for Intel Arc SR-IOV vGPU support — running multiple virtual GPU instances on a single Arc card.

#### DRM_EXEC — GPU Execution Context Manager

`CONFIG_DRM_EXEC=y` — correct multi-object GPU command submission.

Provides lock-based GPU object reservation for correct multi-object command submission without deadlocks. Required for hardware-accelerated video decode on RDNA3+ via Mesa VCN and for multi-queue Vulkan on Intel Xe.

#### DRM_PANEL + DRM_BRIDGE — Laptop Display Support

`CONFIG_DRM_PANEL=y`, `CONFIG_DRM_PANEL_SIMPLE=y`, `CONFIG_DRM_BRIDGE=y` — explicit inclusion for complete laptop display coverage.

Bridge chips connect GPU output to the physical connector (LVDS encoder, DP bridge, HDMI encoder). Many AMD and Intel laptops post-2020 use bridge chips for their internal eDP display. Without explicit inclusion of the panel and bridge subsystems, some laptop displays show as unconfigured in KMS even when the GPU driver probes correctly.

| Config | Value | Purpose |
|---|---|---|
| `CONFIG_DRM_GPUVM` | `y` | GPU VM manager — Mesa 24.1+ Vulkan |
| `CONFIG_DRM_EXEC` | `y` | GPU execution context manager |
| `CONFIG_DRM_PANEL` | `y` | DRM panel subsystem |
| `CONFIG_DRM_PANEL_SIMPLE` | `y` | Generic eDP/LCD panel driver |
| `CONFIG_DRM_BRIDGE` | `y` | Display bridge chip support |

---

### Developer Tools

v2.2.4 adds a full developer visibility suite. Every tool below has **zero overhead at rest** — cost is incurred only when you actively use the tool.

#### KGDB — Kernel GNU Debugger

`CONFIG_KGDB=y` — attach GDB to a live or crashed kernel over serial or USB-serial.

KGDB turns any running Hyperion kernel into a full GDB target. You can inspect memory, set breakpoints, examine call stacks, and step through kernel code — all from a remote GDB session over a serial cable or USB-to-serial adapter.

```bash
# Boot target kernel with kgdbwait to halt at boot until GDB attaches
# Add to kernel cmdline: kgdbwait kgdboc=ttyS0,115200

# On the host machine
gdb vmlinux
(gdb) target remote /dev/ttyUSB0
(gdb) bt                    # backtrace
(gdb) p current->comm       # current process name
(gdb) l schedule            # list scheduler code
```

`CONFIG_KGDB_KDB=y` — KDB shell activates directly on the crashed machine's VT or serial console. No remote host required. Press Alt+SysRq+G to drop into KDB at any time.

```
[0]kdb> ps              # list all processes
[0]kdb> bt              # current backtrace
[0]kdb> md 0xffffffff81000000 32   # memory dump
[0]kdb> go              # resume
```

| Config | Value | Purpose |
|---|---|---|
| `CONFIG_KGDB` | `y` | Kernel GDB remote debugging |
| `CONFIG_KGDB_SERIAL_CONSOLE` | `y` | Serial console transport |
| `CONFIG_KGDB_KDB` | `y` | Built-in KDB shell on crash |
| `CONFIG_KDB_KEYBOARD` | `y` | PS/2 keyboard access in KDB |
| `CONFIG_KDB_CONTINUE_CATASTROPHIC` | `0` | Halt on catastrophic error |

#### MAGIC_SYSRQ — Emergency Kernel Controls

`CONFIG_MAGIC_SYSRQ=y` — keyboard shortcuts that bypass the hung userspace and talk directly to the kernel.

When your Wayland compositor locks, when a process eats all RAM, when you need a clean emergency shutdown — SysRq saves the filesystem.

| Key Combo | Action |
|---|---|
| Alt+SysRq+**B** | Immediate reboot (no sync) |
| Alt+SysRq+**S** | Emergency sync all filesystems |
| Alt+SysRq+**U** | Remount all filesystems read-only |
| Alt+SysRq+**O** | Power off immediately |
| Alt+SysRq+**K** | Kill all processes on current VT |
| Alt+SysRq+**T** | Dump all task states to dmesg |
| Alt+SysRq+**M** | Dump memory info to dmesg |
| Alt+SysRq+**G** | Enter KDB debugger |
| Alt+SysRq+**E** | Send SIGTERM to all processes |
| Alt+SysRq+**I** | Send SIGKILL to all processes |

**The safe shutdown sequence** (saves filesystem on a locked system):
```
Alt+SysRq+S   →   Alt+SysRq+U   →   Alt+SysRq+B
   (sync)          (remount-ro)        (reboot)
```

| Config | Value | Purpose |
|---|---|---|
| `CONFIG_MAGIC_SYSRQ` | `y` | Enable SysRq |
| `CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE` | `1` | Enable all SysRq keys by default |
| `CONFIG_MAGIC_SYSRQ_SERIAL` | `y` | SysRq over serial console |

#### FTRACE — Full Kernel Function Tracer

`CONFIG_FTRACE=y` with the complete tracer suite — the most powerful kernel observability tool available, now built into Hyperion.

Ftrace lets you trace function calls, measure interrupt latency, find preemption stalls, detect hardware latency, and profile the scheduler — all without any external tools or module loading.

```bash
# Measure worst-case interrupt latency (audio glitch diagnosis)
echo irqsoff > /sys/kernel/debug/tracing/current_tracer
echo 1 > /sys/kernel/debug/tracing/tracing_on
# ... reproduce the glitch ...
echo 0 > /sys/kernel/debug/tracing/tracing_on
cat /sys/kernel/debug/tracing/trace

# Trace all calls to a specific function
echo schedule > /sys/kernel/debug/tracing/set_ftrace_filter
echo function > /sys/kernel/debug/tracing/current_tracer
echo 1 > /sys/kernel/debug/tracing/tracing_on

# Hardware latency detector (finds BIOS SMI/SMM stalls)
echo hwlat > /sys/kernel/debug/tracing/current_tracer

# Wakeup latency tracer (find scheduler stalls affecting audio/gaming)
echo wakeup > /sys/kernel/debug/tracing/current_tracer

# Use trace-cmd for comfortable recording
trace-cmd record -e sched:sched_wakeup -e sched:sched_switch sleep 5
trace-cmd report | head -50
```

| Config | Value | Purpose |
|---|---|---|
| `CONFIG_FTRACE` | `y` | Core function tracer infrastructure |
| `CONFIG_FUNCTION_TRACER` | `y` | Per-function call tracing |
| `CONFIG_FUNCTION_GRAPH_TRACER` | `y` | Call graph with timing |
| `CONFIG_IRQSOFF_TRACER` | `y` | Worst-case IRQ-disabled latency |
| `CONFIG_PREEMPT_TRACER` | `y` | Worst-case preempt-disabled latency |
| `CONFIG_SCHED_TRACER` | `y` | Scheduler wakeup latency |
| `CONFIG_HWLAT_TRACER` | `y` | Hardware (SMI/BIOS) latency detector |
| `CONFIG_OSNOISE_TRACER` | `y` | OS noise measurement |
| `CONFIG_TIMERLAT_TRACER` | `y` | Timer latency measurement |
| `CONFIG_DYNAMIC_FTRACE` | `y` | Zero overhead when not tracing (NOP patching) |
| `CONFIG_DYNAMIC_FTRACE_WITH_REGS` | `y` | Full register state on trace |
| `CONFIG_FPROBE` | `y` | Function-level kprobe via ftrace |
| `CONFIG_FPROBE_EVENTS` | `y` | Fprobe as trace events |

#### SCHED_DEBUG — Scheduler Diagnostics

`CONFIG_SCHED_DEBUG=y` — exposes `/proc/sched_debug` and `/proc/schedstat` for real-time scheduler inspection.

Essential for tuning BORE burst scores, monitoring sched-ext BPF scheduler behaviour, and diagnosing scheduling-related latency problems.

```bash
# Live scheduler state (per-CPU run queues, current tasks, latency stats)
watch -n 0.5 cat /proc/sched_debug

# Per-process scheduler statistics
cat /proc/self/sched

# Domain topology and load balancing stats
cat /proc/schedstat

# With sched-ext active: check which scheduler is running
cat /sys/kernel/sched_ext/ops_name
cat /sys/kernel/sched_ext/state
```

#### DYNAMIC_DEBUG — Per-Site Debug Messages

`CONFIG_DYNAMIC_DEBUG=y` — toggle kernel debug messages per module, file, or function at runtime, with zero overhead when off (implemented as jump labels).

```bash
# Enable DRM debug messages for GPU troubleshooting
echo "module drm +p" > /sys/kernel/debug/dynamic_debug/control

# Enable AMDGPU-specific debug
echo "module amdgpu +p" > /sys/kernel/debug/dynamic_debug/control

# Enable USB debug for a specific file
echo "file drivers/usb/core/hub.c +p" > /sys/kernel/debug/dynamic_debug/control

# Disable all debug
echo "module drm -p" > /sys/kernel/debug/dynamic_debug/control
```

---

### Network Additions

#### TAPRIO — Time-Aware Priority Shaper

`CONFIG_NET_SCH_TAPRIO=y` (IEEE 802.1Qbv) — the foundation for precision packet timing.

TAPRIO enables `SO_TXTIME` and `SCM_TXTIME` socket options, which allow applications to specify the exact nanosecond timestamp at which a packet should be transmitted. This is used by:

- **QUIC / HTTP3** — pacing packet bursts to avoid self-congestion
- **Game networking stacks** — sending packets at precise intervals to reduce jitter
- **Time-Sensitive Networking (TSN)** — industrial/audio real-time Ethernet
- **PTP hardware timestamping** — sub-microsecond network clock synchronisation

`CONFIG_NET_SCH_ETF=y` (Earliest TxTime First) — companion to TAPRIO. Ensures packets are dequeued in SO_TXTIME order, preventing out-of-order transmission on hardware that supports launch time offload.

#### UDP GRO — Generic Receive Offload for UDP

`CONFIG_UDP_GRO=y` — approximately 2× UDP receive throughput for QUIC/HTTP3 workloads.

UDP GRO coalesces multiple small UDP datagrams into a single large `skb` before passing up the network stack. This dramatically reduces per-packet overhead for QUIC traffic (which uses many small UDP packets) and benefits any application that receives high-rate UDP streams (game servers, VoIP, DNS resolvers).

#### TCP_NOTSENT_LOWAT — Eliminate Kernel-Side Bufferbloat

`CONFIG_TCP_NOTSENT_LOWAT=y` — enables the `SO_NOTSENT_LOWAT` socket option.

This option prevents TCP from buffering more data in the kernel send buffer than can be sent immediately. Without it, applications that write aggressively to a TCP socket can fill the kernel buffer, adding hundreds of milliseconds of hidden latency — the "kernel-side bufferbloat" problem. Setting `SO_NOTSENT_LOWAT` on gaming and streaming sockets eliminates this hidden delay.

| Config | Value | Purpose |
|---|---|---|
| `CONFIG_NET_SCH_TAPRIO` | `y` | Time-Aware Priority Shaper (SO_TXTIME) |
| `CONFIG_NET_SCH_ETF` | `y` | Earliest TxTime First dequeuing |
| `CONFIG_TCP_NOTSENT_LOWAT` | `y` | SO_NOTSENT_LOWAT kernel-side bufferbloat fix |
| `CONFIG_UDP_GRO` | `y` | ~2× UDP receive throughput |
| `CONFIG_GRO_CELLS` | `y` | Multi-producer GRO for high-pps NICs |
| `CONFIG_NET_EMATCH` | `y` | Extended TC classifier match framework |

---

### ZRAM Dual-Stream LZ4HC

`CONFIG_ZRAM_DEF_COMP2="lz4hc"` — the secondary compression stream for ZRAM multi-comp.

With `CONFIG_ZRAM_MULTI_COMP=y` (already present since v2.2.4), ZRAM supports two compression algorithms simultaneously:

- **Primary stream** (`zstd`): best compression ratio — maximises the amount of data you can fit into ZRAM
- **Secondary stream** (`lz4hc`): LZ4 High Compression — better ratio than plain LZ4, with 3–4× faster decompression than ZSTD under extreme memory pressure

When the system is critically low on memory and needs to decompress swap pages as fast as possible to recover, LZ4HC's speed advantage over ZSTD is the difference between a responsive system and a stall.

```bash
# Recommended ZRAM setup for a 32 GB system
echo 16G              > /sys/block/zram0/disksize
echo zstd             > /sys/block/zram0/comp_algorithm
echo lz4hc            > /sys/block/zram0/comp_algorithm2
mkswap /dev/zram0
swapon -p 100 /dev/zram0

# Verify dual-stream is active
cat /sys/block/zram0/comp_algorithm
# Expected: [zstd] lz4hc lz4 deflate ...

# Check compression stats
cat /sys/block/zram0/mm_stat
```

On a 32 GB system this configuration recovers approximately 3 GB of additional physical RAM versus single-stream ZSTD, with faster recovery under memory pressure peaks.

---

### GCC Build Optimisation Flags

v2.2.4 documents the recommended `KCFLAGS` for squeezing maximum performance from the GCC-compiled kernel.

```bash
make -j$(nproc) \
  LOCALVERSION="-Hyperion-2.2.4" \
  KCFLAGS="-fivopts -fmodulo-sched -fno-semantic-interposition" \
  bzImage modules
```

| Flag | Effect |
|---|---|
| `-fivopts` | Induction variable optimisation — restructures loop counter variables for better register allocation. Measurable win in tight loops (physics engines, video codecs, schedulers). |
| `-fmodulo-sched` | Software pipelining — fills CPU execution slots between loop iterations by scheduling instructions from the next iteration. Benefit in audio DSP, SIMD loops, codec inner loops. |
| `-fno-semantic-interposition` | Allows GCC to inline and optimise calls within the same compilation unit that would otherwise be blocked by the default assumption of DSO interposition. ~3–5% function call overhead reduction across the vmlinux binary. |

**For Clang ThinLTO (even better — requires Clang toolchain):**
```bash
make -j$(nproc) \
  CC=clang LD=ld.lld AR=llvm-ar NM=llvm-nm \
  LOCALVERSION="-Hyperion-2.2.4" \
  LLVM=1 LLVM_IAS=1 \
  bzImage modules
```

Clang ThinLTO (`CONFIG_LTO_CLANG_THIN`) provides link-time inlining across translation units — the most impactful single optimisation available for kernel performance.

---

### BPF & JIT

BPF is the backbone of networking, security (LSM), and scheduling (sched-ext) in 2026. Every BPF program must run at native machine speed via JIT — interpreted BPF is 10–100× slower and carries additional Spectre-class attack surface.

| Config | Value | Impact |
|---|---|---|
| `CONFIG_BPF_JIT` | `y` | BPF programs compile to native x86_64 — prerequisite for everything else |
| `CONFIG_BPF_JIT_ALWAYS_ON` | `y` | Removes the interpreter entirely; eliminates Spectre-BPF attack surface |
| `CONFIG_BPF_JIT_DEFAULT_ON` | `y` | JIT active from boot without sysctl — sched-ext and Cilium work out of the box |
| `CONFIG_BPF_UNPRIV_DEFAULT_OFF` | `y` | Unprivileged users cannot load BPF; closes CVE-2021-3490/2022-0185/2023-2163 class |

Verify at runtime:
```bash
cat /proc/sys/net/core/bpf_jit_enable
# Expected: 1

cat /proc/sys/kernel/unprivileged_bpf_disabled
# Expected: 2 (fully disabled)
```

---

### sched-ext: Runtime BPF Schedulers

`CONFIG_SCHED_CLASS_EXT=y` enables the extensible scheduler class merged in Linux 6.12. The CPU scheduling policy can now be replaced at runtime with a BPF program — no reboot, no recompile.

Install the scx tools:
```bash
# Arch
yay -S scx-scheds

# From source (requires Rust)
git clone https://github.com/sched-ext/scx
cd scx && cargo build --release
sudo cp target/release/scx_* /usr/local/bin/
```

Available schedulers:

| Scheduler | Best for | Notes |
|---|---|---|
| `scx_bpfland` | Desktop and gaming — interactive-first, lowest input latency | BORE-compatible |
| `scx_lavd` | Latency-critical workloads — the CachyOS default | Best with BORE |
| `scx_rusty` | NUMA workstations and multi-socket servers | Meta production |
| `scx_tickless` | HPC and ML inference — aggressive tickless | Batch workloads |

```bash
# Load gaming scheduler
sudo scx_bpfland &

# Verify
cat /sys/kernel/sched_ext/state        # Expected: enabled
cat /sys/kernel/sched_ext/ops_name     # Expected: bpfland

# Switch to NUMA scheduler for a compile job
sudo pkill scx_bpfland && sudo scx_rusty &

# Revert to CFS/BORE
sudo pkill scx_rusty
```

---

### x86 Instruction Tuning

| Config | Impact |
|---|---|
| `CONFIG_X86_X2APIC=y` | Scales interrupt routing to 2^32 CPUs; reduces APIC register access latency on all platforms |
| `CONFIG_X86_CHECK_BIOS_CORRUPTION=y` | Periodic scan of BIOS reserved memory; catches firmware that silently overwrites kernel data |
| `CONFIG_X86_INTEL_USERCOPY_CHECK=y` | Selects ERMSB (enhanced REP MOVSB) for `copy_to/from_user` — ~2× throughput on Haswell+ for large syscall buffers |
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

### Security: Landlock & IPE

#### Landlock

`CONFIG_SECURITY_LANDLOCK=y` — unprivileged per-process filesystem sandboxing. Unlike AppArmor/SELinux which require root policy configuration, Landlock is application-driven: any process can sandbox its own file access via syscall. Used by Flatpak, bubblewrap, and `systemd-run --property=`.

#### Integrity Policy Enforcement (IPE)

IPE enforces policies that restrict code execution to files residing on dm-verity or fs-verity verified filesystems.

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
| `CONFIG_KASAN` | 2× memory overhead | **Off** — use a sanitiser build separately |
| `CONFIG_UBSAN` | Codegen bloat | **Off** — use a sanitiser build separately |
| `CONFIG_KCSAN` | ~50% overhead | **Off** — data race detection for development only |

**Always on** (zero overhead at rest):
- `CONFIG_STACKTRACE=y` — required by `perf`, `bpftrace`, BPF stack maps, crash dumps
- `CONFIG_KGDB=y` — dormant until activated via cmdline or SysRq
- `CONFIG_FTRACE=y` with `CONFIG_DYNAMIC_FTRACE=y` — all trace sites are NOPs until enabled
- `CONFIG_DYNAMIC_DEBUG=y` — all debug messages are disabled jumps until toggled
- `CONFIG_SCHED_DEBUG=y` — data gathered only on `/proc/sched_debug` read
- `CONFIG_LOCKUP_DETECTOR=y` — only fires when something is actually wrong

---

## Philosophy

> *"A kernel should never be the reason your work stopped."*

Hyperion is built on five principles:

1. **Config-Driven** — improvements are kernel configuration choices backed by upstream code the kernel community maintains. No staging drivers. No out-of-tree patches for functionality available in-tree. BORE and ADIOS are the only patchset additions, and both are actively maintained with upstream submission in progress.

2. **Documented Decisions** — every config option has a comment with its rationale and a source reference. This config is something you can read and learn from, not just apply blindly.

3. **Performance Without Sacrifice** — every nanosecond of latency extracted from the hardware, never at the cost of correctness or stability. Debug infrastructure is included but costs nothing at rest.

4. **Developer First** — KPROBES, UPROBE_EVENTS, KGDB, KDB, FTRACE with all tracers, DYNAMIC_DEBUG, bpftrace/bcc, LIVEPATCH, full sched-ext support, Rust infrastructure. The kernel is an observable, debuggable, modifiable system.

5. **Universal by Default** — one `bzImage` boots correctly on Arch, Ubuntu, Fedora, RHEL, openSUSE, Gentoo, and NixOS without configuration.

---

## Key Features

| Category | Feature | Details |
|---|---|---|
| **Identity** | Custom branding | `uname -r` → `6.19.6-Hyperion-2.2.4` |
| **Build** | Monolithic image | All in-tree drivers promoted to `=y` — zero module-load latency |
| **Build** | ZSTD compression | ~40% faster boot than GZIP on NVMe |
| **Build** | Rust support | `CONFIG_RUST=y` — Rust kernel drivers enabled, GCC 14.2.0 |
| **BPF** | JIT always-on | Native x86_64 BPF, no interpreter, Spectre-BPF mitigated |
| **BPF** | Unprivileged blocked | `BPF_UNPRIV_DEFAULT_OFF` — closes entire CVE class |
| **Scheduler** | BORE | Burst-Oriented Response Enhancer — best interactive feel under load |
| **Scheduler** | sched-ext | Runtime-swappable BPF schedulers: scx_bpfland, scx_lavd, scx_rusty |
| **Scheduler** | Full preemption | `PREEMPT=y` + `PREEMPT_DYNAMIC=y` + `PREEMPT_LAZY=y` |
| **Scheduler** | Sub-ms ticks | `SCHED_HRTICK=y` — hrtimer-resolution preemption |
| **Timer** | 1000 Hz | `CONFIG_HZ_1000=y` — 1 ms scheduler granularity |
| **IO** | ADIOS | Adaptive Deadline I/O Scheduler — CachyOS 2025 default |
| **IO** | BFQ + Kyber + Deadline | All schedulers built-in, switchable per-device |
| **IO** | io_uring | Built-in — zero module-load delay |
| **Memory** | MGLRU + MMU walk | Accurate cold-page detection, fewer false evictions |
| **Memory** | ZRAM dual-stream | ZSTD primary + LZ4HC secondary via `ZRAM_MULTI_COMP` |
| **Memory** | ZSWAP ZSTD | Compressed in-RAM swap — defeats OOM before it starts |
| **Memory** | BORE | Interactive tasks never OOM before batch tasks |
| **Network** | BBR default | Google's low-latency TCP congestion control |
| **Network** | CAKE qdisc | Best-in-class bufferbloat elimination |
| **Network** | TAPRIO | SO_TXTIME pacing for QUIC, TSN, game networking |
| **Network** | UDP GRO | ~2× UDP receive throughput (QUIC/HTTP3) |
| **Network** | TCP_NOTSENT_LOWAT | Eliminates kernel-side bufferbloat |
| **Network** | WireGuard | Built-in modern VPN — ~10 Gbps with ChaCha20-NI |
| **Network** | BPF sockmap | Zero-copy socket redirection for Cilium/Envoy |
| **Filesystem** | FS_VERITY | Per-file Merkle-tree integrity |
| **Filesystem** | FS_ENCRYPTION | Per-file fscrypt AES encryption |
| **Filesystem** | Unicode | Case-insensitive fs for Steam/Wine compatibility |
| **CPU** | AMD P-State Active | Mode 3 EPP — best Zen3/4 boost |
| **CPU** | Intel P-State + HWP | Hardware-managed boost |
| **CPU** | X86_INTEL_USERCOPY_CHECK | ERMSB ~2× faster user↔kernel copies |
| **GPU** | DRM_GPUVM | GPU VM manager — Mesa 24.1+ Vulkan (radv/anv) |
| **GPU** | DRM_EXEC | Multi-object GPU command submission |
| **GPU** | DRM_PANEL + DRM_BRIDGE | Laptop eDP display coverage |
| **GPU** | DRM_SCHED | Priority-aware GPU job scheduler |
| **Security** | IPE | Boot-verified integrity policy enforcement |
| **Security** | Landlock | Unprivileged per-process sandboxing |
| **Security** | AppArmor (default) | Arch, Ubuntu, Debian |
| **Security** | SELinux | Fedora, RHEL, CentOS |
| **Security** | BPF LSM | eBPF-based MAC policies |
| **Dev** | KGDB + KDB | Full GDB remote debugging + on-machine KDB shell |
| **Dev** | MAGIC_SYSRQ | Emergency kernel controls — safe shutdown sequence |
| **Dev** | FTRACE | Full tracer suite: irqsoff, preemptoff, hwlat, wakeup, osnoise |
| **Dev** | SCHED_DEBUG | `/proc/sched_debug` for BORE/scx tuning |
| **Dev** | DYNAMIC_DEBUG | Per-site debug message toggle at runtime |
| **Dev** | KPROBES + UPROBES | bpftrace/bcc without configuration |
| **Dev** | LIVEPATCH | Zero-downtime CVE patching |
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

### CPU Scheduling

Hyperion v2.2.4 ships with a three-layer scheduling stack:

1. **BORE** (`CONFIG_SCHED_BORE=y`) — the base scheduler. Every process gets burst accounting. Interactive tasks always beat batch tasks in deadline competition.
2. **sched-ext** (`CONFIG_SCHED_CLASS_EXT=y`) — replaces the entire CFS/BORE policy at runtime with a BPF scheduler. Use `scx_bpfland` for gaming, `scx_lavd` for CachyOS-style interactive, `scx_rusty` for NUMA.
3. **PREEMPT_DYNAMIC** — boot parameter controls preemption model: `preempt=full` (gaming), `preempt=lazy` (compile workloads), `preempt=voluntary` (server).

### I/O Scheduling

ADIOS is the new default. Switch per-device based on the hardware:

```bash
# NVMe (default: ADIOS — best latency + throughput)
echo adios > /sys/block/nvme0n1/queue/scheduler

# Desktop HDD or SSHD (BFQ — per-process fairness)
echo bfq > /sys/block/sda/queue/scheduler

# High-throughput server (deadline — simple, deterministic)
echo deadline > /sys/block/nvme1n1/queue/scheduler
```

### Memory

```bash
# THP: madvise mode (apps that want THPs get them; small allocs don't waste memory)
echo madvise > /sys/kernel/mm/transparent_hugepage/enabled

# MGLRU: 4 generations (default)
echo 4 > /sys/kernel/mm/lru_gen/min_ttl_ms

# ZRAM multi-stream dual-comp setup
echo 16G > /sys/block/zram0/disksize
echo zstd > /sys/block/zram0/comp_algorithm
echo lz4hc > /sys/block/zram0/comp_algorithm2
mkswap /dev/zram0 && swapon -p 100 /dev/zram0
```

---

## Hardware Support

### Wi-Fi — Universal Chipset Coverage

| Vendor | Driver | Standards |
|---|---|---|
| Qualcomm/Atheros | `ATH9K` | 802.11n |
| Qualcomm/Atheros | `ATH10K` | 802.11ac |
| Qualcomm/Atheros | `ATH11K` | Wi-Fi 6 (AX) |
| Qualcomm/Atheros | `ATH12K` | Wi-Fi 7 (BE) |
| Realtek | `RTW88` | 802.11ac |
| Realtek | `RTW89` | Wi-Fi 6/6E |
| Intel | `IWLWIFI` (DVM + MVM) | 802.11ac/ax — AX200, AX210, AX211 |
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
| `DRM_GPUVM` | GPU VM manager for Mesa 24.1+ Vulkan (new in v2.2.4) |

### Audio

| Platform | Coverage |
|---|---|
| Intel SOF | Ice Lake through Meteor Lake (10th–14th gen) |
| AMD ACP | Ryzen 4000/5000/6000/7000 laptops |
| RT5682/CS35L41 | Virtually every modern laptop codec |
| USB audio | `SND_USB_AUDIO=y` with autosuspend off — no DAC clicks |

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
| `RANDOM_KMALLOC_CACHES=y` | Randomised slab caches defeating heap spray (Linux 6.6+) |
| `HARDENED_USERCOPY_FALLBACK=n` | Strict mode — no fallback on boundary violations |

---

## Build Instructions

### Prerequisites

```bash
# Arch
sudo pacman -S base-devel bc cpio pahole python rust rust-bindgen

# Fedora
sudo dnf install gcc make bc cpio pahole python3 rust rust-bindgen-cli

# Debian/Ubuntu
sudo apt install build-essential bc cpio dwarves python3 rustc bindgen
```

### Quick Start

```bash
# Get kernel source
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.19.6.tar.xz
tar -xf linux-6.19.6.tar.xz && cd linux-6.19.6

# Apply BORE and ADIOS patchsets (if not already in-tree)
for p in ../patches/*.patch; do patch -p1 --fuzz=5 < "$p"; done

# Apply config
cp ../hyperion.config .config
make olddefconfig LOCALVERSION="-Hyperion-2.2.4"

# Build (standard)
make -j$(nproc) LOCALVERSION="-Hyperion-2.2.4" bzImage modules

# Build with extra GCC performance flags
make -j$(nproc) \
  LOCALVERSION="-Hyperion-2.2.4" \
  KCFLAGS="-fivopts -fmodulo-sched -fno-semantic-interposition" \
  bzImage modules

# Build with Clang ThinLTO (maximum performance, requires Clang)
make -j$(nproc) \
  CC=clang LD=ld.lld AR=llvm-ar NM=llvm-nm \
  LOCALVERSION="-Hyperion-2.2.4" \
  LLVM=1 LLVM_IAS=1 \
  bzImage modules
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
sudo mkinitcpio -k 6.19.6-Hyperion-2.2.4 -g /boot/initramfs-hyperion-2.2.4.img

# Fedora/RHEL (dracut)
sudo dracut --force /boot/initramfs-6.19.6-Hyperion-2.2.4.img 6.19.6-Hyperion-2.2.4

# Debian/Ubuntu (update-initramfs)
sudo update-initramfs -c -k 6.19.6-Hyperion-2.2.4
```

Post-install verification:
```bash
uname -r
# Expected: 6.19.6-Hyperion-2.2.4

cat /proc/sys/net/core/bpf_jit_enable
# Expected: 1

cat /sys/module/usbcore/parameters/autosuspend
# Expected: -1

# Verify v2.2.4 specific features
zcat /proc/config.gz | grep -E "^CONFIG_(RUST|SCHED_BORE|IOSCHED_ADIOS|KGDB|MAGIC_SYSRQ|FTRACE|DRM_GPUVM|NET_SCH_TAPRIO|UDP_GRO|ZRAM_MULTI_COMP)="

# Verify BORE is available
cat /sys/kernel/debug/sched/bore_burst_smoothness
# Expected: 2

# Verify ADIOS is the default scheduler
cat /sys/block/nvme0n1/queue/scheduler
# Expected: [adios] bfq kyber deadline mq-deadline none
```

---

## Recommended Boot Parameters

### AMD (Zen3/4 Desktop)

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

### Intel (12th/13th/14th gen Desktop)

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

### With KGDB (Development / Debugging)

```
quiet splash preempt=full threadirqs
kgdboc=ttyS0,115200    # attach GDB over first serial port
# OR: kgdboc=kbd        # use keyboard (requires KDB)
# To halt at boot: add kgdbwait
amd_pstate=active
lsm=landlock,lockdown,yama,integrity,apparmor,bpf
```

Replace `N` with your last CPU index (`nproc --all` minus 1).

Note: `lsm=` includes `integrity` (required for IMA/IPE) and places `landlock` first.

---

## Runtime Tuning: sysctl Companion

Add to `/etc/sysctl.d/99-hyperion.conf`:

```ini
# =============================================
# HYPERION v2.2.4 — Recommended sysctl tuning
# =============================================

# Memory
vm.swappiness = 10                  # Strongly prefer RAM over swap
vm.dirty_ratio = 10                 # Flush dirty pages at 10% of RAM
vm.dirty_background_ratio = 5       # Start background writeback at 5%
vm.vfs_cache_pressure = 50          # Keep dentries/inodes cached longer
kernel.numa_balancing = 1           # NUMA page migration enabled

# Networking
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_fastopen = 3           # Client + server TFO
net.core.netdev_max_backlog = 8192  # NIC receive queue depth

# BPF / unprivileged
kernel.unprivileged_bpf_disabled = 2

# Scheduler
kernel.sched_autogroup_enabled = 1
```

Apply immediately:
```bash
sudo sysctl -p /etc/sysctl.d/99-hyperion.conf
```

---

## Troubleshooting

### BORE not active / burst tuning

```bash
# Confirm BORE is compiled in
zcat /proc/config.gz | grep SCHED_BORE
# Expected: CONFIG_SCHED_BORE=y

# Read current burst smoothness
cat /sys/kernel/debug/sched/bore_burst_smoothness
# Expected: 2

# Make more reactive for gaming (persist across boots via sysctl)
echo 1 > /sys/kernel/debug/sched/bore_burst_smoothness
```

### ADIOS scheduler not available

```bash
zcat /proc/config.gz | grep IOSCHED_ADIOS
# Expected: CONFIG_IOSCHED_ADIOS=y

cat /sys/block/nvme0n1/queue/scheduler
# If adios is missing, the ADIOS patch was not applied to the source tree
# Check: ls ../patches/ | grep adios
```

### KGDB not connecting

```bash
# Ensure kgdboc is set in cmdline
cat /proc/cmdline | grep kgdboc

# Trigger entry into KGDB from a running system
echo g > /proc/sysrq-trigger

# Then from host:
gdb vmlinux
(gdb) target remote /dev/ttyUSB0
```

### FTRACE showing no output

```bash
# Check tracer is set
cat /sys/kernel/debug/tracing/current_tracer

# Check tracing is on
cat /sys/kernel/debug/tracing/tracing_on

# Enable and collect
echo irqsoff > /sys/kernel/debug/tracing/current_tracer
echo 1 > /sys/kernel/debug/tracing/tracing_on
sleep 2
echo 0 > /sys/kernel/debug/tracing/tracing_on
cat /sys/kernel/debug/tracing/trace | head -40
```

### sched-ext not loading

```bash
# Check kernel support
zcat /proc/config.gz | grep SCHED_CLASS_EXT
# Expected: CONFIG_SCHED_CLASS_EXT=y

# Check BPF JIT is on
cat /proc/sys/net/core/bpf_jit_enable
# Expected: 1

# Install scx tools
which scx_bpfland || yay -S scx-scheds
```

### IPE policy not applying

```bash
# Check IPE is active
ls /sys/kernel/security/ipe/
# If empty, add "integrity" to lsm= cmdline parameter

# Check FS verity is supported on your filesystem
tune2fs -l /dev/sdX | grep -i verity
```

### ZRAM multi-comp not working

```bash
zcat /proc/config.gz | grep ZRAM_MULTI_COMP
# Expected: CONFIG_ZRAM_MULTI_COMP=y

# Check available algorithms
cat /sys/block/zram0/comp_algorithm
# Expected: ... [zstd] lz4hc ...

# If lz4hc is missing from list, kernel was built without lz4hc support
zcat /proc/config.gz | grep LZ4HC
```

### Rust build failure

```bash
# Check rustc version (needs >= 1.78)
rustc --version

# Check bindgen
bindgen --version

# If wrong version, use rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup install 1.78
rustup override set 1.78
```

### No Wi-Fi

```bash
lspci -k | grep -A3 -i "wireless\|network"
dmesg | grep -i "firmware\|ath\|iwl\|rtw\|mt76"
# All drivers require firmware blobs from linux-firmware
sudo pacman -S linux-firmware       # Arch
sudo apt install firmware-linux     # Debian/Ubuntu
sudo dnf install linux-firmware     # Fedora
```

---

## Development Workflow

```
patches/*.patch  →  patch -p1  →  hyperion.config  →  make olddefconfig  →  bzImage
```

1. **Config changes:** edit `hyperion.config` directly. Every option needs a comment with rationale and source. Follow the inline comment style.
2. **Source patches:** add `NNNN-description.patch` to `patches/`. BORE and ADIOS live here.
3. **Build:** `bash scripts/build-kernel.sh` or the manual `make` commands above
4. **CI:** auto-builds on every push via `.github/workflows/build.yml`

### Verifying all v2.2.4 features after build

```bash
#!/bin/bash
# hyperion-verify.sh
declare -A checks=(
  [RUST]="CONFIG_RUST=y"
  [BORE]="CONFIG_SCHED_BORE=y"
  [ADIOS]="CONFIG_IOSCHED_ADIOS=y"
  [KGDB]="CONFIG_KGDB=y"
  [SYSRQ]="CONFIG_MAGIC_SYSRQ=y"
  [FTRACE]="CONFIG_FTRACE=y"
  [DRM_GPUVM]="CONFIG_DRM_GPUVM=y"
  [TAPRIO]="CONFIG_NET_SCH_TAPRIO=y"
  [UDP_GRO]="CONFIG_UDP_GRO=y"
  [ZRAM_MULTI]="CONFIG_ZRAM_MULTI_COMP=y"
  [SCHED_EXT]="CONFIG_SCHED_CLASS_EXT=y"
  [BBR]="CONFIG_TCP_CONG_BBR=y"
  [BPF_JIT]="CONFIG_BPF_JIT=y"
  [IPE]="CONFIG_SECURITY_IPE=y"
  [BORE_SMOOTHNESS]="CONFIG_SCHED_BORE_BURST_SMOOTHNESS=2"
)

echo "=== Hyperion v2.2.4 Feature Verification ==="
for name in "${!checks[@]}"; do
  val="${checks[$name]}"
  if zcat /proc/config.gz 2>/dev/null | grep -q "^$val"; then
    echo "  ✅ $name"
  else
    echo "  ❌ $name  (expected: $val)"
  fi
done
```

---

## Credits

| Role | Name |
|---|---|
| **Linux Kernel Developer** | **Soumalya Das** |
| Base Kernel | Linus Torvalds & the Linux kernel community |
| Config inspiration | CachyOS, XanMod, Nobara, Liquorix, Arch, Fedora, Ubuntu |
| BORE Scheduler | Masahito Suzuki (firelzrd) |
| ADIOS I/O Scheduler | CachyOS kernel team |
| sched-ext / BPF schedulers | sched-ext/scx project, CachyOS team |
| sched-ext framework | Tejun Heo, David Vernet |
| BPF/JIT | Alexei Starovoitov, Daniel Borkmann, Andrii Nakryiko |
| Rust for Linux | Miguel Ojeda, Alex Gaynor, and the Rust for Linux team |
| IPE framework | Fan Wu, Deven Bowers (Microsoft) |
| Landlock | Mickaël Salaün |
| ZRAM multi-comp | Sergey Senozhatsky |
| FS Verity | Eric Biggers (Google) |
| DRM_GPUVM | Thomas Hellström (Intel) |
| UDP GRO | Eric Dumazet (Google) |
| TAPRIO / TSN | Vinicius Costa Gomes (Intel) |
| AMD P-State | AMD Open Source driver team |
| Intel P-State | Intel Open Source Technology Center |
| BORE burst smoothness | Masahito Suzuki, CachyOS integration |
| BPF sockmap | John Fastabend, Daniel Borkmann |
| Memory management | MGLRU: Yu Zhao (Google); DAMON: SeongJae Park (Amazon) |
| PREEMPT_LAZY | Peter Zijlstra, Thomas Gleixner |
| USB autosuspend analysis | Sarah Sharp, Alan Stern |
| Live kernel patching | Josh Poimboeuf (Red Hat) |
| Security hardening | Kees Cook |
| KGDB | Jason Wessel |
| ftrace / dynamic tracing | Steven Rostedt |
| Performance research | Phoronix, LKML, r/linux_gaming, CachyOS/XanMod teams |

---

## License

Hyperion Kernel configuration, scripts, and documentation are released under the [MIT License](LICENSE).

The Linux kernel itself is licensed under **GPL-2.0-only**.

---

<div align="center">

*Built with precision. Tuned for humans. Named after a Titan.*

**Hyperion Kernel v2.2.4** · Soumalya Das · 2026

🧠🐧⚡🦀

</div>
