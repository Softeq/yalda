# Yet Another Linux Development Approach

## Build components
- call ./build
- It support various of parameters.
- Use ./build --version [version] or -v [version] for fetching specific kernel.
- Use ./build --no-download or ./build -n for ommitting kernel and busybox download.
- Use ./build --arch [arch] to build for specific target architecture.
- At the moment [arch] can be x86_64 or arm

## Quick start
- call ./runqemu
- run gdb (i.e ./rungdb)
- attach the kernel via ```target remote :1234```
- add breakpoint ```b do_init_module```
- load symbols ```lx-symbols <PATH TO YOUR MODULE>```
- add breakpoint to you module functions. (make sure __init attribure is not used for your module init function)
- enjoy

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
