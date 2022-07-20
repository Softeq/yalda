SHELL := /bin/bash

target ?= $(shell uname -m)

export ROOT_DIR=${PWD}

config_dir := ${PWD}/config
scripts_dir := ${PWD}/scripts

yalda_exe := ${ROOT_DIR}/yalda

kconfig_exe := kconfig-mconf
kconfig := ${config_dir}/kconf/Kconfig-main

.PHONY: *config* all *build* kernel busybox whistle rootfs run* clean*

all: build

build: .build-kernel .build-busybox .build-whistle .build-rootfs

config: menuconfig

menuconfig:
	${kconfig_exe} ${kconfig}

config-kernel:
	. ${scripts_dir}/env && make -C "$${KERNEL_DIR}" menuconfig

config-busybox:
	. ${scripts_dir}/env && make -C "$${BUSYBOX_DIR}" menuconfig


.build-kernel:
	${yalda_exe} kernel build

kernel: build-kernel
build-kernel:
	${MAKE} KERNEL_BUILD="y" .build-kernel
	
.build-busybox:
	${yalda_exe} busybox build

busybox: build-busybox
build-busybox:
	${MAKE} BUSYBOX_BUILD="y" .build-busybox

.build-whistle:
	${yalda_exe} whistle build

whistle: build-whistle
build-whistle:
	${MAKE} WHISTLE_BUILD="y" .build-whistle

.build-rootfs:
	${yalda_exe} rootfs build

rootfs: build-rootfs
build-rootfs:
	${MAKE} ROOTFS_BUILD="y" .build-rootfs
	
run-qemu:
	${yalda_exe} qemu run

run-gdb:
	${yalda_exe} gdb run

clean:
	rm -rf .config* 2>/dev/null
