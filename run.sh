#!/bin/bash
qemu-system-x86_64 -vga std -smp 8 -m 256 -drive id=disk,file=mini.img,if=none -device ahci,id=ahci -device ide-drive,drive=disk,bus=ahci.0 -name "BareMetal OS" -net nic,model=i82551

