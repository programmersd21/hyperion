# Hyperion Kernel — System Tuning Guide
# Author: Soumalya Das | 2026
#
# Apply these settings for maximum performance on Hyperion Kernel.
# These are userspace tunables that complement the kernel config.
# =============================================================================

# =============================================================
# SYSCTL SETTINGS
# Apply: sudo sysctl --system
# Or: sudo cp this file to /etc/sysctl.d/99-hyperion.conf
# =============================================================

# --------------------
# VM / Memory
# --------------------

# Swappiness: 10 = prefer RAM, only swap under real pressure
# Works WITH zswap — light swapping to compressed RAM is OK
vm.swappiness = 10

# VFS cache pressure: 50 = less aggressive inode/dentry reclaim
# Keeps filesystem metadata in RAM longer
vm.vfs_cache_pressure = 50

# Dirty ratio: higher = more dirty pages buffered before writeout
# Better throughput for large sequential writes (video, compilation)
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
vm.dirty_expire_centisecs = 3000
vm.dirty_writeback_centisecs = 500

# Overcommit: allow optimistic allocation (needed by some games/JIT)
vm.overcommit_memory = 1
vm.overcommit_ratio = 50

# mmap: large mmap count for games and ML frameworks (needs this!)
vm.max_map_count = 2147483642

# Transparent hugepages (kernel config uses MADVISE)
# Tell DAMON/khugepaged to be less aggressive
kernel.numa_balancing = 1

# --------------------
# Kernel / Scheduler
# --------------------

# Watchdog: leave enabled — matches kernel config
kernel.nmi_watchdog = 1

# Panic: don't panic on oops, auto-reboot after 30s on panic
kernel.panic = 30
kernel.panic_on_oops = 0

# Sysrq: enable for emergency recovery (magic keys)
kernel.sysrq = 1

# PID max: increase for large workloads
kernel.pid_max = 4194304

# Perf event paranoia: 1 allows user perf profiling (needed by gamescope/perf)
kernel.perf_event_paranoid = 1

# --------------------
# Network — BBR + FQ
# --------------------

# Use BBR as TCP congestion control
net.ipv4.tcp_congestion_control = bbr

# FQ qdisc on all interfaces
net.core.default_qdisc = fq

# Increase socket buffers for high-throughput gaming/streaming
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.core.rmem_default = 1048576
net.core.wmem_default = 1048576
net.ipv4.tcp_rmem = 4096 1048576 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864

# SYN flood protection (already in kernel config via SYN_COOKIES)
net.ipv4.tcp_syncookies = 1

# Reduce TIME_WAIT sockets
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15

# TCP Fast Open: reduce handshake latency
net.ipv4.tcp_fastopen = 3

# Netdev budget: process more packets per NAPI poll cycle
net.core.netdev_budget = 600
net.core.netdev_budget_usecs = 8000

# --------------------
# File Descriptors
# --------------------
fs.file-max = 2097152
fs.nr_open = 2097152

# inotify limits (needed by VS Code, Electron, file watchers)
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 1024

# =============================================================
# UDEV RULES
# Save to: /etc/udev/rules.d/60-hyperion-io.rules
# =============================================================
# Set BFQ for all rotational disks (HDDs)
# ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

# Set Kyber for NVMe SSDs — low latency is the priority
# ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="kyber"

# Set queue depth higher for NVMe
# ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/nr_requests}="2048"

# =============================================================
# CPU GOVERNOR SETTINGS
# =============================================================
# Already handled by CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
# To change at runtime:
#   echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
#   echo schedutil   | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# AMD P-State EPP: balanced_performance profile (slight power savings)
# echo balance_performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

# =============================================================
# HUGEPAGES (optional — for databases, VMs)
# =============================================================
# echo 1024 | sudo tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
# vm.nr_hugepages = 1024

# =============================================================
# ZRAM SETUP SCRIPT
# =============================================================
# Run this at boot to enable zram swap:
#
# modprobe zram
# echo zstd > /sys/block/zram0/comp_algorithm
# echo $(( $(grep MemTotal /proc/meminfo | awk '{print $2}') * 1024 / 2 )) > /sys/block/zram0/disksize
# mkswap /dev/zram0
# swapon /dev/zram0 -p 100
#
# This creates a zram device half the size of your RAM,
# compressed with ZSTD, with high swap priority so it's used before disk.
