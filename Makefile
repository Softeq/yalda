SHELL := /bin/bash

target ?= $(shell uname -m)

export ROOT_DIR=${PWD}

config_dir := ${PWD}/config
scripts_dir := ${PWD}/scripts

kconfig_exe := kconfig-mconf
kconfig := ${config_dir}/Kconfig-main

build := ${scripts_dir}/build
run := ${scripts_dir}/run

.PHONY: *config* all build* kernel busybox whistle rootfs run* clean*

all: build

build: kernel busybox whistle rootfs

config: menuconfig

menuconfig:
	${kconfig_exe} ${kconfig}

config-kernel:
	. ${scripts_dir}/env && make -C "$${KERNEL_DIR}" menuconfig

config-busybox:
	. ${scripts_dir}/env && make -C "$${BUSYBOX_DIR}" menuconfig

build-kernel: kernel
kernel:
	KERNEL_BUILD="y" ${build}/kernel

build-busybox: busybox
busybox:
	BUSYBOX_BUILD="y" ${build}/busybox

build-whistle: whistle
whistle:
	WHISTLE_BUILD="y" ${build}/whistle

build-rootfs: rootfs
rootfs:
	ROOTFS_BUILD="y" ${build}/rootfs

run-qemu:
	${run}/qemu

run-gdb:
	${run}/gdb

clean:
	rm -rf .config* 2>/dev/null
