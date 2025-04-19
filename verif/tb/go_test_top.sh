#!/bin/bash

source ~/usbdisk/Xilinx/Vivado/2024.2/settings64.sh

mkdir -p run_dir
pushd run_dir

analyze_cmd="xvlog \
                -i /home/eric/Projects/gb2/rtl/include \
                -i /home/eric/Projects/gb2/verif/include \
                -sv \
                /home/eric/Projects/gb2/rtl/include/sm83_pkg.sv \
                /home/eric/Projects/gb2/rtl/register_file.sv \
                /home/eric/Projects/gb2/rtl/idu.sv \
                /home/eric/Projects/gb2/rtl/alu.sv \
                /home/eric/Projects/gb2/rtl/stages/decode.sv \
                /home/eric/Projects/gb2/rtl/control.sv \
                /home/eric/Projects/gb2/rtl/mock_mem.sv \
                /home/eric/Projects/gb2/rtl/sm83_core.sv \
                /home/eric/Projects/gb2/rtl/sm83_top.sv \
                /home/eric/Projects/gb2/verif/tb/sm83_top_tb.sv"

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
xsim --gui work.sm83_top_tb --view /home/eric/Projects/gb2/verif/tb/run_dir/work.sm83_top_tb.wcfg &
popd