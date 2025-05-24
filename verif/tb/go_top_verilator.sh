#!/bin/bash

relpath_rtl=../../../rtl
relpath_rtl_inc=$relpath_rtl/include
relpath_verif=../..
relpath_verif_include=$relpath_verif/include

echo "compile the gb asm file..."
pushd ../../asm/scripts
basename=$(basename $1 .gameboy.asm)
./build.sh $1 #TODO exit if compile fails
popd

echo "replacing correct mem path..."
python3 replace_mem_path.py ../../rtl/mock_mem.sv ../../../asm/scripts/build_dir/$basename.mem

rm -rf verilator_dir
mkdir -p verilator_dir
pushd verilator_dir

verilator --trace +incdir+$relpath_rtl \
                  +incdir+$relpath_rtl/stages \
                  +incdir+$relpath_rtl_inc \
                  +incdir+$relpath_verif \
                  +incdir+$relpath_verif/tb \
                  +incdir+$relpath_verif_include \
                  -DVERILATOR_SIM \
                  --build --exe --cc --trace --timing \
                  -Wno-ASCRANGE \
                  sm83_top.sv \
                  ../sm83_top_tb.cpp \
                  -o sm83_top_tb \

./obj_dir/sm83_top_tb

popd