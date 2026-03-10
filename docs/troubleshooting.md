# Hyperion Kernel — Troubleshooting Guide

This document explains the complete failure chain and how Hyperion prevents it.

---

## The Module Failure Chain

```
 Kernel header missing
        │
        ▼
 DKMS module build failure
        │
        ▼
 module loading failure  (insmod/modprobe error)
        │
        ▼
 missing /dev device nodes
        │
        ▼
 applications fail silently or crash
```

### How Hyperion Breaks This Chain

| Failure Point | Hyperion Prevention |
|---|---|
| **Headers missing** | `install-headers.sh` is mandatory part of install; `CONFIG_IKHEADERS=y` provides runtime fallback |
| **DKMS build fails** | `CONFIG_MODVERSIONS=y` ensures correct symbol CRCs; headers at standard path |
| **Module load fails** | `CONFIG_MODVERSIONS` gives clean error instead of kernel panic; modules path correct |
| **Missing /dev nodes** | `CONFIG_DEVTMPFS=y` + `CONFIG_DEVTMPFS_MOUNT=y` auto-creates device nodes |
| **Silent failures** | PSI + lockup detectors + verbose oops = nothing fails silently |

---

## Common Issues and Fixes

### Issue: `uname -r` doesn't show Hyperion

**Symptom:** `uname -r` shows old kernel after reboot  
**Cause:** Bootloader not updated, or wrong entry selected

```bash
# Check current boot entry
sudo efibootmgr -v          # UEFI systems
cat /proc/cmdline           # See what was actually booted

# Force Hyperion as default (GRUB)
sudo grep -i hyperion /boot/grub/grub.cfg
sudo grub-set-default "Advanced options>Hyperion"
sudo update-grub

# For systemd-boot, check /boot/loader/entries/
ls /boot/loader/entries/
```

---

### Issue: DKMS build failure after kernel install

**Symptom:**
```
Error! Bad return status for module build on kernel: 6.19.6-Hyperion-0.1.0
```

**Step 1: Check if headers exist**
```bash
ls /usr/src/linux-headers-6.19.6-Hyperion-0.1.0/
# If empty or missing → run install-headers.sh
sudo bash /path/to/hyperion-kernel/scripts/install-headers.sh
```

**Step 2: Verify build symlink**
```bash
readlink /lib/modules/6.19.6-Hyperion-0.1.0/build
# Must point to /usr/src/linux-headers-6.19.6-Hyperion-0.1.0

# Fix if wrong:
sudo ln -sfn /usr/src/linux-headers-6.19.6-Hyperion-0.1.0 \
    /lib/modules/6.19.6-Hyperion-0.1.0/build
```

**Step 3: Try building DKMS module manually**
```bash
sudo dkms build -m nvidia -v 550.54.14 -k 6.19.6-Hyperion-0.1.0 --verbose
```

**Step 4: Check module build log**
```bash
cat /var/lib/dkms/<module>/<version>/build/make.log
```

---

### Issue: Module won't load — "version magic" mismatch

**Symptom:**
```
insmod: ERROR: could not insert module foo.ko: Invalid module format
dmesg: foo: version magic '6.19.6 ...' should be '6.19.6-Hyperion-0.1.0 ...'
```

**Cause:** Module was built for a different kernel version  
**Fix:** Rebuild the module for the current kernel

```bash
sudo dkms remove <module>/<version> --all
sudo dkms install <module>/<version> -k $(uname -r)
```

---

### Issue: `/dev` device nodes missing

**Symptom:** Application says device not found; `/dev/sda`, `/dev/nvidia0` etc. missing

**Check devtmpfs is mounted:**
```bash
mount | grep devtmpfs
# Should show: devtmpfs on /dev type devtmpfs

# If not mounted:
sudo mount -t devtmpfs devtmpfs /dev
```

**Trigger udev re-scan:**
```bash
sudo udevadm trigger
sudo udevadm settle
ls /dev/
```

**Check if module is loaded:**
```bash
lsmod | grep nvidia
lsmod | grep <driver>

# Load manually
sudo modprobe nvidia
# Check dmesg for errors
dmesg | tail -20
```

---

### Issue: Kernel panic / oops on boot

**Symptom:** System doesn't boot, shows kernel panic text

**Read the crash log (pstore):**
```bash
# After reboot into a working kernel
ls /sys/fs/pstore/
cat /sys/fs/pstore/dmesg-*
```

**Read via serial console:**  
Add `console=ttyS0,115200` to kernel cmdline in GRUB, then capture via:
```bash
screen /dev/ttyS0 115200
```

**Common causes and fixes:**

| Panic message | Cause | Fix |
|---|---|---|
| `VFS: Unable to mount root fs` | Initrd missing AHCI/NVMe driver | Rebuild initrd: `sudo dracut -f` or `sudo update-initramfs -u` |
| `Kernel panic - not syncing: No working init found` | systemd not found | Boot rescue, check /sbin/init |
| `BUG: unable to handle kernel NULL pointer` | Bad module | Remove recently added DKMS module |

---

### Issue: System runs hot / fans loud

**Check thermal governor:**
```bash
cat /sys/class/thermal/thermal_zone*/available_policies
cat /sys/class/thermal/thermal_zone*/policy

# Set power_allocator for smarter control
echo "power_allocator" | sudo tee /sys/class/thermal/thermal_zone0/policy
```

**Check CPU temperatures:**
```bash
sensors
# Should show coretemp/k10temp readings

# Install if not present
sudo apt install lm-sensors
sudo sensors-detect
```

**Check thermal throttling:**
```bash
# AMD
dmesg | grep -i "thermal throttling"
cat /sys/class/hwmon/hwmon*/temp*_crit_alarm

# Intel
sudo rdmsr 0x1b1   # Requires msr module: sudo modprobe msr
```

---

### Issue: OOM killer fires unexpectedly

**Read OOM log:**
```bash
dmesg | grep -E "(Out of memory|oom_kill|Killed process)"
journalctl -k | grep -i oom
```

**Check PSI (pressure stall info):**
```bash
cat /proc/pressure/memory
cat /proc/pressure/cpu
cat /proc/pressure/io
# High "full" values indicate saturation
```

**Check zswap is active:**
```bash
cat /sys/module/zswap/parameters/enabled
# Should be Y

grep -r . /sys/kernel/debug/zswap/ 2>/dev/null
```

**Enable zram if needed:**
```bash
sudo modprobe zram
echo zstd > /sys/block/zram0/comp_algorithm
echo 4G > /sys/block/zram0/disksize
sudo mkswap /dev/zram0
sudo swapon /dev/zram0 -p 100
```

---

### Issue: Audio stutters / latency spikes during gaming

**Check scheduler:**
```bash
cat /sys/kernel/debug/sched/features | grep AUTOGROUP

# Verify HZ=1000
grep "^CONFIG_HZ=" /boot/config-$(uname -r)
# Expected: CONFIG_HZ=1000
```

**Set CPU governor to performance:**
```bash
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

**Check for IRQ affinity issues:**
```bash
cat /proc/interrupts | head -20
# Set audio IRQ to specific core if needed
```

---

## Getting Help

1. Check `dmesg | tail -50` for kernel messages
2. Check `journalctl -k --since=-10m` for recent kernel log
3. Open a GitHub Issue with the output of:

```bash
uname -a
dmesg | tail -100
sudo dkms status
ls -la /lib/modules/$(uname -r)/build
ls /usr/src/ | grep hyperion
```
