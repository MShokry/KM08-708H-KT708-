#!/bin/bash
# Quick build script for KT708 on macOS

set -e

# Navigate to your project
cd ./KM08-708H-KT708-

# Clone OpenWrt if not exists
if [ ! -d "openwrt-build" ]; then
    git clone https://github.com/openwrt/openwrt.git openwrt-build
fi

cd openwrt-build
git checkout openwrt-24.10
git pull

# Copy configurations
cp ../diy-part1.sh .
cp ../diy-part2.sh .
cp ../.config .

# Copy custom files
if [ -d "../files" ]; then
    cp -r ../files .
fi

# Make scripts executable
chmod +x diy-part1.sh diy-part2.sh

# Run build process
./diy-part1.sh
./scripts/feeds update -a
./scripts/feeds install -a
./diy-part2.sh

make defconfig
make download -j8 V=s
make -j$(sysctl -n hw.ncpu) V=s

echo "Build complete! Firmware located in bin/targets/ramips/mt7621/"