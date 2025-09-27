#!/bin/bash
#rgbds assembler (https://rgbds.gbdev.io/)
#usage: build_test.sh [ASM_FILE]
fname=$(basename $1 .gameboy.asm)
mkdir -p build_dir
pushd build_dir
echo "assembling..."
rgbasm -i ../../tests/include -i ../../tests/regression/tests -o $fname.o $1
if [ $? -ne 0 ]; then
    exit 1
fi

echo "linking..."
#the -x option removes padding
rgblink -o $fname.gb $fname.o
if [ $? -ne 0 ]; then
    exit 1
fi
echo "created build_dir/$fname.gb. converting to .mem..."
rm -f $fname.mem
python3 ../convert_to_mem.py $fname.gb $fname.mem
echo "done. created build_dir/$fname.mem"
popd
