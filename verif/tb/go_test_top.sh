#!/bin/bash
#my vivado install is in a weird location, so i added this here.
#i will assume that you have already sourced your settings64.sh, so leaving it commented out.
#source ~/usbdisk/Xilinx/Vivado/2024.2/settings64.sh

echo "compile the gb asm file..."
pushd ../../asm/scripts
basename=$(basename $1 .gameboy.asm)
./build.sh $1
popd

echo "replacing correct mem path..."
python3 replace_mem_path.py ../../rtl/mock_mem.sv ../../../asm/scripts/build_dir/$basename.mem

echo "run the vivado commands..."
mkdir -p run_dir
pushd run_dir

relpath_rtl=../../../rtl
relpath_rtl_inc=$relpath_rtl/include
relpath_verif=../..
relpath_verif_include=$relpath_verif/include

analyze_cmd="xvlog \
                -i $relpath_rtl_inc \
                -i $relpath_verif_include \
                -sv \
                $relpath_rtl_inc/sm83_pkg.sv \
                $relpath_rtl/register_file.sv \
                $relpath_rtl/idu.sv \
                $relpath_rtl/alu.sv \
                $relpath_rtl/stages/decode.sv \
                $relpath_rtl/control.sv \
                $relpath_rtl/mock_mem_pathed.sv \
                $relpath_rtl/sm83_core.sv \
                $relpath_rtl/sm83_top.sv \
                $relpath_verif/tb/sm83_top_tb.sv"

elab_cmd="xelab sm83_top_tb -debug typical"

# Run the analyze command
eval $analyze_cmd
if [ $? -ne 0 ]; then
    echo "Analyze command failed. Exiting."
    exit 1
fi

# Run the elaborate command
eval $elab_cmd
if [ $? -ne 0 ]; then
    echo "Elaborate command failed. Exiting."
    exit 1
fi

# Run the simulation if both commands are successful
xsim --gui work.sm83_top_tb --view work.sm83_top_tb.wcfg &
popd