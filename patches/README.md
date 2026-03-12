# Hyperion Kernel Patches

This directory contains patches applied on top of the Linux 2.2.1 baseline.

---

## Patch Format

All patches follow the standard Linux kernel patch format:

```
From: Author Name <email>
Subject: [PATCH] subsystem: description

Long description of the change.

Tested-on: hardware description
Reference: URL to upstream discussion if applicable

Signed-off-by: Soumalya Das <geniussantu1983@gmail.com>
```

## Applying Patches

Patches are applied automatically by `scripts/build-kernel.sh` in sorted order.

Manual application:
```bash
cd linux-2.2.1
git apply ../patches/0001-example.patch
# or
patch -p1 < ../patches/0001-example.patch
```

## Current Patches

| Filename | Description | Status |
|---|---|---|
| *(none yet)* | Baseline release uses stock 2.2.1 | — |

## Adding Patches

1. Name your patch: `NNNN-subsystem-description.patch` (e.g. `0001-sched-tune-latency.patch`)
2. Include a proper header (see above)
3. Place it in this directory
4. Open a PR with benchmark data showing the improvement
