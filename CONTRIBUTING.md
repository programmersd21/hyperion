# Contributing to Hyperion Kernel

Thank you for your interest in contributing to Hyperion Kernel!  
This document outlines the standards and workflow for contributions.

---

## Code of Conduct

By participating in this project you agree to abide by the
[Code of Conduct](CODE_OF_CONDUCT.md).

---

## Ways to Contribute

- **Bug reports** — open a GitHub Issue using the bug report template
- **Config suggestions** — open a GitHub Issue with benchmark data or reference
- **Patches** — open a Pull Request following the patch format below
- **Documentation** — improve `docs/` or inline comments in `hyperion.config`
- **Testing** — test on new hardware and report results in Discussions

---

## Development Setup

```bash
git clone https://github.com/soumalyadev/hyperion-kernel.git
cd hyperion-kernel
git checkout -b feature/my-improvement
```

---

## Submitting Patches

1. Place patch files in `patches/` named as `NNNN-description.patch`
   (e.g. `0001-sched-tune-autogroup-latency.patch`)
2. Each patch must have a proper header:

```
From: Your Name <your@email.com>
Subject: [PATCH] subsystem: brief description

Longer description of what this patch does and why.
Tested on: hardware description
Reference: link to upstream thread / LWN / Phoronix

Signed-off-by: Your Name <your@email.com>
```

3. Config changes must include a comment explaining the rationale
4. Open a Pull Request targeting `main`

---

## Config Change Policy

All `hyperion.config` changes must include:
- A comment in the config file explaining the option
- A reference (benchmark, upstream doc, distro precedent) in the PR description
- Before/after performance data if the change affects performance

---

## Testing Requirements

Before submitting a PR, confirm:
- [ ] Kernel builds without errors: `make -j$(nproc)`
- [ ] Boots successfully
- [ ] `dkms status` shows all modules built
- [ ] `uname -r` shows the correct Hyperion version string

---

## Coding Style

Follow the [Linux kernel coding style](https://www.kernel.org/doc/html/latest/process/coding-style.html) for any C patches.  
Shell scripts follow Google's [Shell Style Guide](https://google.github.io/styleguide/shellguide.html).
