#!/bin/bash
#clear stuff
rm -rf manager.app
rm -rf pure64.sys
rm -rf kernel.sys
rm -rf software.sys
#pure64 building
cd Pure64
./build.sh
cp pure64.sys ../
cd ../
#kernel building
cd src/x86-64
nasm kernel.asm -o ../../kernel.sys
cd ../..
#manager building
cd programs
gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o libBareMetal.o libBareMetal.c
gcc -c -m64 -nostdlib -nostartfiles -nodefaultlibs -fomit-frame-pointer -mno-red-zone -o manager.o manager.c
ld -T manager.ld -o manager.app manager.o libBareMetal.o
cp manager.app ../
cd ../
#write files to disk image
cat pure64.sys kernel.sys > software.sys
dd if=software.sys of=mini.img bs=512 seek=16 conv=notrunc
dd if=manager.app of=mini.img bs=1M seek=1 conv=notrunc
