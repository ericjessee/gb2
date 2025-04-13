#!/bin/bash

mkdir -p run_dir
pushd run_dir

analyze_cmd="xvlog -sv \
                /home/eric/Projects/gb2/rtl/include/sm83_pkg.sv \
                /home/eric/Projects/gb2/rtl/alu.sv"

# Run the analyze command
eval $analyze_cmd
if [ $? -eq 0 ]; then
    # Only run these commands if analyze_cmd was successful
    xelab alu -debug typical
    xsim --runall work.alu
else
    echo "Analysis failed. Exiting."
    exit 1
fi
popd