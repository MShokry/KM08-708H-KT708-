# Mercury KM08-708H Configuration Fix

## Problem
The build was configured for `raisecom,msg1500-x-00` device instead of `mercury,km08-708h`, causing the error:
```
Image check failed: Device mercury,km08-708h not supported by this image
Supported devices: raisecom,msg1500-x-00
```

## Solution Applied

### 1. Fixed .config file
- **Disabled Raisecom device**: Changed `CONFIG_TARGET_ramips_mt7621_DEVICE_raisecom_msg1500-x-00=y` to `# CONFIG_TARGET_ramips_mt7621_DEVICE_raisecom_msg1500-x-00 is not set`
- **Added Mercury device**: Added `CONFIG_TARGET_ramips_mt7621_DEVICE_mercury_km08-708h=y`
- **Updated target profile**: Changed from `CONFIG_TARGET_PROFILE="DEVICE_raisecom_msg1500-x-00"` to `CONFIG_TARGET_PROFILE="DEVICE_mercury_km08-708h"`

### 2. Configuration Validation
Created `validate_config.sh` script to verify all settings are correct.

## Current Configuration
- **Device**: Mercury KM08-708H
- **Target**: ramips/mt7621
- **Profile**: DEVICE_mercury_km08-708h
- **SoC**: MediaTek MT7621AT
- **Wi-Fi**: MediaTek MT7615DN Dual Band

## Build Instructions

### Option 1: Using build.sh (Automated)
```bash
cd /Users/mshokry/PWS/openwrt/KM08-708H-KT708-
chmod +x build.sh
./build.sh
```

### Option 2: Manual Build
```bash
cd /Users/mshokry/PWS/openwrt/KM08-708H-KT708-

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
```

## Output Location
After successful build, firmware will be located in:
```
openwrt-build/bin/targets/ramips/mt7621/
```

Look for files like:
- `openwrt-*-ramips-mt7621-mercury_km08-708h-squashfs-sysupgrade.bin`
- `openwrt-*-ramips-mt7621-mercury_km08-708h-squashfs-factory.bin`

## Verification
Run the validation script to confirm configuration:
```bash
./validate_config.sh
```

## Custom Settings Applied
- **LAN IP**: 192.168.3.1 (changed from default 192.168.1.1)
- **Hostname**: KT708-Router (changed from OpenWrt)
- **Wi-Fi**: MT7615 drivers enabled for dual-band support
- **Packages**: Essential Wi-Fi packages (hostapd-common, wpad-openssl, wireless-regdb) included

The configuration is now ready for building Mercury KM08-708H firmware!