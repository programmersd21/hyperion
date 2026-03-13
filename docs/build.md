# Building Hyperion Kernel

## Prerequisites

### Arch Linux
```bash
sudo pacman -S base-devel bc kmod cpio flex bison libelf pahole git
```

### Debian / Ubuntu
```bash
sudo apt install build-essential bc bison flex libssl-dev libelf-dev \
  libncurses-dev dwarves rsync cpio wget git pahole
```

### Fedora / RHEL
```bash
sudo dnf install gcc make bison flex elfutils-libelf-devel \
  openssl-devel ncurses-devel bc git pahole
```

---

## Build Steps

### 1. Get the kernel source

```bash
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.19.6.tar.xz
tar -xf linux-6.19.6.tar.xz
cd linux-6.19.6
```

### 2. Apply patches

```bash
for patch in ../patches/*.patch; do
  echo "  → applying $(basename "$patch")"
  patch -p1 --fuzz=5 < "$patch"
done
```

The only patch in v2.2.4 adds a documentation file — it is safe on any
Linux 6.x tree and cannot conflict with upstream changes.

### 3. Apply Hyperion config

```bash
cp ../hyperion.config .config
make olddefconfig LOCALVERSION="-Hyperion-2.2.4"
```

`make olddefconfig` resolves all new symbols to their Kconfig defaults.
After this step the key performance options are verified present:

```bash
grep -E "^CONFIG_(BPF_JIT|BPF_JIT_ALWAYS_ON|SCHED_CLASS_EXT|FS_VERITY|\
SECURITY_IPE|ZRAM_MULTI_COMP|SECURITY_LANDLOCK|STACKTRACE)=" .config
```

### 4. Optional: Review with menuconfig

```bash
make menuconfig
```

Notable locations for the new v2.2.4 options:

| Config | menuconfig path |
|---|---|
| `CONFIG_BPF_JIT_ALWAYS_ON` | General setup → BPF subsystem |
| `CONFIG_SCHED_CLASS_EXT` | General setup → CPU scheduler |
| `CONFIG_FS_VERITY` | File systems → FS Verity |
| `CONFIG_FS_ENCRYPTION` | File systems → FS Encryption |
| `CONFIG_UNICODE` | File systems → Native language support |
| `CONFIG_ZRAM_MULTI_COMP` | Device Drivers → Block devices → ZRAM |
| `CONFIG_SECURITY_IPE` | Security options → IPE |
| `CONFIG_SECURITY_LANDLOCK` | Security options → Landlock |

### 5. Build

```bash
make -j$(nproc) \
  LOCALVERSION="-Hyperion-2.2.4" \
  KCFLAGS="-pipe" \
  bzImage modules
```

### 6. Install

```bash
sudo make modules_install
sudo make install

# Update bootloader
sudo update-grub                               # Debian/Ubuntu
sudo grub2-mkconfig -o /boot/grub2/grub.cfg   # Fedora/RHEL
sudo grub-mkconfig -o /boot/grub/grub.cfg      # Arch
```

---

## Automated Build

```bash
# Full automated build
bash scripts/build-kernel.sh --auto

# With interactive config review step
bash scripts/build-kernel.sh --interactive

# With a specific kernel source directory
bash scripts/build-kernel.sh --source /path/to/linux-6.19.6
```

---

## CI Build (GitHub Actions)

The `.github/workflows/build.yml` pipeline:

1. Downloads `linux-6.19.6.tar.xz` (cached by tarball hash)
2. Applies all `patches/*.patch` in sorted order
3. Copies `hyperion.config` → `.config` and runs `make olddefconfig`
4. Builds `bzImage modules` with ccache acceleration
5. Packages `bzImage + System.map + hyperion.config` as a release artifact

Build trigger: `workflow_dispatch` (manual). All caches keyed on the
config hash and patch hash so a config-only change invalidates the
correct cache layers.

---

## Post-Build Verification

```bash
# Verify uname
uname -r
# Expected: 6.19.6-Hyperion-2.2.4

# Verify BPF JIT is active
cat /proc/sys/net/core/bpf_jit_enable
# Expected: 1

# Verify sched-ext is available
ls /sys/kernel/sched_ext/
# Expected: state  ops_name  (when a scx scheduler is loaded)

# Verify IPE is present
ls /sys/kernel/security/ipe/
# Expected: policies  audit  enforce  success_audit

# Verify ZRAM multi-comp
cat /sys/block/zram0/comp_algorithm
# Expected: [zstd] lzo lzo-rle lz4 lz4hc 842

# Verify Landlock is supported
grep landlock /sys/kernel/security/lsm
# Expected: landlock listed

# Verify FS verity
tune2fs -l /dev/sdXN 2>/dev/null | grep -i verity
# Or: getfattr -n user.verity.digest /some/file
```
