#!/bin/bash

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

# Run the analyze command
eval $analyze_cmd
if [ $? -eq 0 ]; then
    # Only run these commands if analyze_cmd was successful
    xelab sm83_top_tb -debug typical
    xsim --runall work.sm83_top_tb
else
    echo "Analysis failed. Exiting."
    exit 1
fi
popd