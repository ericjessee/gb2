#!/bin/bash

#first convert all the sv files to v

mkdir -p ../build

pushd ../../

sv2v --incdir rtl/include --top=sm83_top --write=synth/build -v $(< synth/scripts/synth_filelist.f)
echo "Converted $svfile -> synth/build/$outname"

popd
