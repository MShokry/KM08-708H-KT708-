#!/bin/bash
# Validation script for Mercury KM08-708H configuration

set -e

echo "=== Mercury KM08-708H Configuration Validation ==="

# Check if Mercury device is enabled in .config
echo "Checking Mercury device configuration..."
if grep -q "CONFIG_TARGET_ramips_mt7621_DEVICE_mercury_km08-708h=y" .config; then
    echo "✓ Mercury KM08-708H device is enabled"
else
    echo "✗ Mercury KM08-708H device is NOT enabled"
    exit 1
fi

# Check target profile
echo "Checking target profile..."
if grep -q 'CONFIG_TARGET_PROFILE="DEVICE_mercury_km08-708h"' .config; then
    echo "✓ Target profile is set to Mercury KM08-708H"
else
    echo "✗ Target profile is NOT set to Mercury KM08-708H"
    exit 1
fi

# Check that Raisecom is disabled
echo "Checking Raisecom device is disabled..."
if grep -q "# CONFIG_TARGET_ramips_mt7621_DEVICE_raisecom_msg1500-x-00 is not set" .config; then
    echo "✓ Raisecom device is properly disabled"
else
    echo "✗ Raisecom device might still be enabled"
    exit 1
fi

# Check target architecture
echo "Checking target architecture..."
if grep -q "CONFIG_TARGET_BOARD=\"ramips\"" .config && grep -q "CONFIG_TARGET_SUBTARGET=\"mt7621\"" .config; then
    echo "✓ Target architecture is ramips/mt7621 (correct for Mercury KM08-708H)"
else
    echo "✗ Target architecture is incorrect"
    exit 1
fi

echo ""
echo "=== Configuration Summary ==="
echo "Device: Mercury KM08-708H"
echo "Target: ramips/mt7621"
echo "Profile: DEVICE_mercury_km08-708h"
echo ""
echo "✓ All configurations are correct for Mercury KM08-708H!"
echo "You can now proceed with the build process."