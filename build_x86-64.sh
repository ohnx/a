#!/bin/bash
cd Pure64
./build.sh
cp pure64.sys ../
cd ../
cd src/x86-64
nasm kernel.asm -o ../../kernel.sys
cd ../..
cat pure64.sys kernel.sys > software.sys
dd if=software.sys of=mini.img bs=512 seek=16 conv=notrunc
