# DKMS Compatibility Guide

Hyperion Kernel treats DKMS as a first-class citizen. This document explains
how we guarantee external modules always build and load correctly.

---

## Why DKMS Breaks (General Causes)

```
 ┌─────────────────────────────────────────────────┐
 │           DKMS Failure Root Causes              │
 ├─────────────────────────────────────────────────┤
 │ 1. Kernel headers not installed                 │
 │ 2. /lib/modules/$(uname -r)/build symlink wrong │
 │ 3. Symbol versioning mismatch (MODVERSIONS)     │
 │ 4. Module not in correct path                   │
 │ 5. Module signed but key not trusted            │
 │ 6. CONFIG_MODULE_COMPRESS mismatch              │
 └─────────────────────────────────────────────────┘
```

---

## Hyperion Config Settings That Prevent DKMS Failures

### CONFIG_MODULES=y
Modules are supported. Without this, no external module can ever load.

### CONFIG_MODULE_UNLOAD=y
Allows modules to be unloaded and reloaded — required for DKMS reinstall
without a full reboot.

### CONFIG_MODVERSIONS=y
**The most critical DKMS setting.**

Every exported kernel symbol gets a CRC checksum based on its type signature.
When a module is loaded, the kernel checks:
- Module's expected CRC for `symbol_foo` matches kernel's exported CRC

If they don't match: `ERROR: Module was compiled for a different kernel version`
(clean rejection at load time, **not** a silent panic).

Without this: ABI changes cause silent corruption or random crashes.

### CONFIG_KALLSYMS=y
Symbol table is built into the kernel. Required for:
- BPF programs
- `perf` profiling
- `crash` utility
- Some DKMS modules that look up symbols dynamically

### CONFIG_IKHEADERS=y
**The DKMS fallback.**

Embeds kernel headers as a compressed tarball at `/sys/kernel/kheaders.tar.xz`.
When `/usr/src/linux-headers-*` is somehow missing or incomplete, DKMS can
extract headers from this runtime path.

Enabled in `hyperion.config`. Zero cost when not used.

### CONFIG_DEVTMPFS=y + CONFIG_DEVTMPFS_MOUNT=y
After a DKMS module is loaded, its device nodes must appear in `/dev/`.
`devtmpfs` makes this automatic — the kernel creates the node as soon as the
driver calls `device_create()`.

Without this: driver loads, no `/dev/foo` appears, application fails silently.

### CONFIG_MODULE_SIG=n (default)
Module signing is **disabled by default** so DKMS can sign its own modules
via its own key infrastructure without fighting the kernel's required-key chain.

To enable for Secure Boot: see [docs/module-signing.md](module-signing.md).

### CONFIG_MODULE_COMPRESS_NONE=y
Modules are stored uncompressed. DKMS builds `.ko` files and needs to install
them — compression adds a step that some older DKMS versions mishandle.

---

## Installing Headers Correctly

```bash
cd linux-6.19.6

# Step 1: Install sanitised user-space API headers
sudo make headers_install INSTALL_HDR_PATH=/usr

# Step 2: Install build headers (what DKMS actually needs)
sudo make modules_prepare

# Step 3: Copy full headers directory
KVER="6.19.6-Hyperion-0.1.1"
sudo mkdir -p /usr/src/linux-headers-${KVER}

# Copy all header files
sudo cp -a . /usr/src/linux-headers-${KVER}/

# Step 4: Create the build symlink
sudo ln -sfn /usr/src/linux-headers-${KVER} \
    /lib/modules/${KVER}/build

# Step 5: Create the source symlink (some modules need this too)
sudo ln -sfn /usr/src/linux-headers-${KVER} \
    /lib/modules/${KVER}/source

# Verify
ls -la /lib/modules/${KVER}/build
# → /lib/modules/6.19.6-Hyperion-0.1.1/build -> /usr/src/linux-headers-6.19.6-Hyperion-0.1.1
```

The `install-headers.sh` script does all of this automatically.

---

## Testing DKMS Compatibility

```bash
# 1. Check all registered modules
sudo dkms status

# 2. Force rebuild all modules for current kernel
sudo dkms autoinstall -k $(uname -r)

# 3. Test specific module
sudo dkms install nvidia/550.54.14 -k $(uname -r)

# 4. Verbose build to diagnose failures
sudo dkms build -m v4l2loopback -v 0.12.7 -k $(uname -r) --verbose

# 5. Check module loading
sudo modprobe v4l2loopback
lsmod | grep v4l2
dmesg | tail -10
```

---

## Example DKMS Workflows

### NVIDIA Driver

```bash
# Install NVIDIA DKMS package
sudo apt install nvidia-dkms-550   # Ubuntu/Debian
sudo dnf install akmod-nvidia       # Fedora (akmods variant)

# Verify
sudo dkms status | grep nvidia
# nvidia/550.54.14, 6.19.6-Hyperion-0.1.1, x86_64: installed ✓

# Load
sudo modprobe nvidia
nvidia-smi
```

### ZFS on Linux

```bash
sudo apt install zfs-dkms zfsutils-linux
sudo dkms status | grep zfs
sudo modprobe zfs
zpool status
```

### VirtualBox

```bash
sudo apt install virtualbox-dkms
sudo dkms status | grep vbox
sudo modprobe vboxdrv
VBoxManage --version
```

---

## Symbol Versioning — Deep Dive

When `CONFIG_MODVERSIONS=y`, the kernel build generates `Module.symvers`.
This file maps every exported symbol to a CRC hash:

```
0xa1b2c3d4    put_user_pages_dirty_lock    vmlinux    EXPORT_SYMBOL
0xb5c6d7e8    schedule                     vmlinux    EXPORT_SYMBOL
```

When a module is built against these headers, it records the expected CRC
for each symbol it uses. At load time, the kernel compares the recorded CRC
with the current kernel's CRC.

**Hyperion provides** `Module.symvers` at:
```
/usr/src/linux-headers-6.19.6-Hyperion-0.1.1/Module.symvers
```

DKMS automatically uses this file during module builds via:
```bash
make -C /lib/modules/$(uname -r)/build M=$(pwd) modules
```
