# Yet Another Linux Development Approach

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
