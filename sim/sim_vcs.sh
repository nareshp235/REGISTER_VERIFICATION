#!/bin/bash

#===============================================================================
# Register Verification Environment V0
#===============================================================================

set -e

ROOT_DIR=$(dirname $(dirname $(realpath $0)))

echo
echo "========================================"
echo " Register Verification V0"
echo "========================================"

echo "ROOT_DIR = $ROOT_DIR"
pwd

echo
echo "Contents of flist:"
cat ../flist/filelist.f

echo
echo "RTL Exists?"
ls -l ../rtl/

echo
echo "TB Exists?"
ls -l ../tb/

cd $ROOT_DIR

echo
echo "Cleaning old results..."

rm -rf simv*
rm -rf csrc
rm -rf ucli.key
rm -rf DVEfiles

rm -f logs/*.log
rm -f waves/*.vpd

mkdir -p logs
mkdir -p waves

echo
echo "Compiling..."

vcs \
    -full64 \
    -sverilog \
    -debug_access+all \
    -kdb \
    -f flist/filelist.f \
    -l logs/compile.log \
    -o simv

echo
echo "Running Simulation..."

./simv \
    -l logs/sim.log

echo
echo "========================================"
echo " Simulation Completed"
echo "========================================"

echo "use cmd -> dve -vpd waves/reg_block.vpd &"

