# SPDX-License-Identifier: GPL-2.0
#
# Makefile for Realtek RTL8192EU in-tree driver
# Hyperion Kernel Project v2.2.2
#

# ── Module object list ────────────────────────────────────────────────────
rtl8192eu-objs := \
	rtl8192eu_usb.o

# ── Build target ──────────────────────────────────────────────────────────
obj-$(CONFIG_RTL8192EU) += rtl8192eu.o

# ── Compiler flags ────────────────────────────────────────────────────────
# -Wno-unused-function: some HAL stubs are intentionally unused
# -Wno-implicit-fallthrough: Realtek code has some intentional fallthroughs
ccflags-y += -I$(srctree)/drivers/net/wireless/realtek/rtl8192eu/include
ccflags-y += -Wno-unused-function
ccflags-y += -Wno-implicit-fallthrough
