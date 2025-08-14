#!/bin/bash
#my vivado install is in a weird location, so i added this here.
#i will assume that you have already sourced your settings64.sh, so leaving it commented out.
source ~/usbdisk/Xilinx/Vivado/2024.2/settings64.sh

# Set ASM to default if not defined
if [ -z "$ASM" ]; then
    ASM="/home/eric/Projects/gb2/asm/tests/regression/regression.gameboy.asm"
fi

# Accept -waves flag regardless of position
waves_flag=0
for arg in "$@"; do
    if [ "$arg" = "-waves" ]; then
        waves_flag=1
        break
    fi
done

echo "compile the gb asm file..."
pushd ../../asm/scripts
basename=$(basename "$ASM" .gameboy.asm)
./build.sh "$ASM" #TODO exit if compile fails
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
if [ $waves_flag -eq 1 ]; then
    xsim --gui work.sm83_top_tb --view work.sm83_top_tb.wcfg &
else
    xsim work.sm83_top_tb -R
fi

popd