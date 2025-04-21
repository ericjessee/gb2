#!/bin/bash
#rgbds assembler (https://rgbds.gbdev.io/)
#usage: build_test.sh [ASM_FILE]
fname=$(basename $1 .gameboy.asm)
mkdir -p build_dir
pushd build_dir
echo "assembling..."
rgbasm -o $fname.o $1
echo "linking..."
#the -x option removes padding
rgblink -o $fname.gb $fname.o
echo "created build_dir/$fname.gb. converting to .mem..."
rm -f $fname.mem
python3 ../convert_to_mem.py $fname.gb $fname.mem
echo "done. created build_dir/$fname.mem"
popd
