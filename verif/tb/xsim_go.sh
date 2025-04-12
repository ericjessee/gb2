#!/bin/bash

mkdir -p run_dir
pushd run_dir

analyze_cmd="xvlog -sv \
                /home/eric/Projects/gb2/rtl/include/sm83_pkg.sv \
                /home/eric/Projects/gb2/rtl/register_file.sv \
                /home/eric/Projects/gb2/verif/tb/reg_file_tb.sv "




# Run the analyze command
eval $analyze_cmd
if [ $? -eq 0 ]; then
    # Only run these commands if analyze_cmd was successful
    xelab reg_file_tb -debug typical
    xsim --runall work.reg_file_tb
else
    echo "Analysis failed. Exiting."
    exit 1
fi
popd