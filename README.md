# Yet Another Linux Development Approach

## Prepare environment
Ubuntu:
```
$ sudo apt install kconfig-frontends
```

Others:
```
$ git clone https://github.com/jameswalmsley/kconfig-frontends
$ cd kconfig-frontends
$ ./bootstrap
$ ./configure
$ make -j$(nproc)
$ sudo make install
```

## Configure YALDA
- generate .config file
```
$ make menuconfig
```

- you can set environment variables by yourself:
```
$ export ROOTFS_OUT=/mnt/iniitrd.cpio.gz
$ export KERNEL_DIR=/mnt/linux-5.14
$ export KERNEL_SOURCE=git
$ make build
```

## Build components
- Build all components:
```
$ make build
```

- You can build separate component
- You can pass env variables before or inside make build-* call
```
$ make build-kernel
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- build-kernel
$ BUSYBOX_DIR=./new-busybox BUSYBOX_SOURCE=git make build-busybox
$ make build-whistle
$ make ROOTFS_OUT=/mnt/initrd.cpio.gz  build-rootfs
$ ...
```

## Quick start
- call `make run-qemu`
- run gdb (i.e `make run-gdb`)
- attach the kernel via ```target remote :1234```
- add breakpoint ```b do_init_module```
- load symbols ```lx-symbols <PATH TO YOUR MODULE>```
- add breakpoint to you module functions. (make sure __init attribure is not used for your module init function)
- enjoy

Also you can use the current host kernel: you need to select `CONFIG_YALDA_RUN_HOST_KERNEL` (`run` - `host kernel` in menuconfig).
Then run `make run-qemu` and `make run-gdb`.

## Description
See scripts please. It is easy
Useful things:
- it mounts ./ path to /mnt/share inside QEMU
- it create and mounts home path to /home and set it as $HOME
- in order to exit use ctrl-a-x
- in order to enter QEMU console use ctrl-a-c
- uncomment -S in order to debug kernel from early begining

## Known issues
- ctrl-c does not work in ash scripts
