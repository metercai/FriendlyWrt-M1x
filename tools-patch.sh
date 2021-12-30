#!/bin/bash
set -eu

TOOLCHAIN=/opt/FriendlyARM/toolchain/
sudo su -c "mkdir -p ${TOOLCHAIN} && tar zxvf toolchain-aarch64_generic_gcc-11.2.0_musl.tgz && mv toolchain-aarch64_generic_gcc-11.2.0_musl ${TOOLCHAIN} && ln -s toolchain-aarch64_generic_gcc-11.2.0_musl ${TOOLCHAIN}6.4-aarch64 "
sudo su -c "mkdir -p ${TOOLCHAIN}4.4.3/ "
cp -rf ./rkbin/* ../rkbin/
cp -rf ./scripts/* ../scripts/
sudo apt install golang-go zip
echo "toolchain patch ok!"
exit 0
