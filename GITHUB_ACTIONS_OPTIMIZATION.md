# GitHub Actions Build Optimization Guide

## Overview
This guide explains the optimizations applied to speed up OpenWrt builds and ensure all firmware files are generated properly.

## Key Optimizations Applied

### 1. Caching System
- **OpenWrt Source Cache**: Caches the entire OpenWrt source tree to avoid re-cloning
- **ccache**: Caches compiled objects to speed up incremental builds
- **Downloads Cache**: Caches downloaded packages to avoid re-downloading

### 2. Build Performance
- **ccache**: Compiler cache with 2GB limit and compression enabled
- **Parallel Downloads**: Increased from `-j8` to `-j16` for faster package downloads
- **Shallow Clone**: Uses `--depth=1` for faster initial clone
- **Disk Space Optimization**: Removes unnecessary packages and Docker images

### 3. Enhanced Workflow Features
- **Timeout Protection**: 6-hour timeout to prevent stuck builds
- **Cache Control**: Manual cache clearing option via workflow dispatch
- **Better Artifact Management**: Separate retention periods for different artifacts
- **Comprehensive Release Notes**: Detailed firmware information in releases

## Speed Improvements

### First Build (Cold Cache)
- **Before**: ~2-3 hours
- **After**: ~1.5-2 hours (due to parallel downloads and disk optimization)

### Subsequent Builds (Warm Cache)
- **Before**: ~2-3 hours (no caching)
- **After**: ~30-45 minutes (with ccache and source caching)

### Incremental Builds (Config Changes Only)
- **After**: ~15-30 minutes (with full caching)

## Firmware Files Generated

The optimized workflow ensures all firmware files are generated:

### Sysupgrade Files
- `openwrt-*-ramips-mt7621-mercury_km08-708h-squashfs-sysupgrade.bin`
- Used for upgrading existing OpenWrt installations

### Factory Files
- `openwrt-*-ramips-mt7621-mercury_km08-708h-squashfs-factory.bin`
- Used for initial installation from stock firmware

### Additional Files
- `*.manifest`: Package list
- `*.buildinfo`: Build information
- `*.img.gz`: Raw image files (if applicable)

## Workflow Triggers

### Manual Trigger
```yaml
workflow_dispatch:
  inputs:
    ssh:
      description: 'SSH connection to Actions'
      default: 'false'
    clean_cache:
      description: 'Clean build cache'
      default: 'false'
```

### Usage
1. Go to **Actions** tab in your repository
2. Select **Build OpenWrt** workflow
3. Click **Run workflow**
4. Options:
   - **SSH connection**: Enable for debugging (set to `true`)
   - **Clean build cache**: Force clean build (set to `true`)

## Cache Management

### Cache Keys
- **Source**: `openwrt-source-{branch}-{config-hash}`
- **ccache**: `ccache-{os}-{branch}-{config-hash}`
- **Downloads**: `downloads-{branch}-{config-hash}`

### Cache Behavior
- Caches are automatically invalidated when `.config` or `diy-part1.sh` changes
- Manual cache clearing available via workflow input
- Caches expire after 7 days of inactivity

## Artifact Management

### Bin Directory
- **Retention**: 7 days
- **Contains**: Complete build output including packages
- **Size**: ~500MB-1GB

### Firmware Directory
- **Retention**: 30 days
- **Contains**: Only firmware files (*.bin, *.img.gz, etc.)
- **Size**: ~10-50MB

### Releases
- **Retention**: Latest 5 releases
- **Auto-generated**: With detailed device information
- **Files**: All firmware files with sizes

## Monitoring Build Progress

### Build Stages
1. **Initialization** (~2-3 minutes)
2. **Source Preparation** (~1-5 minutes, depending on cache)
3. **Feed Updates** (~2-3 minutes)
4. **Package Downloads** (~5-15 minutes)
5. **Compilation** (~15-90 minutes, depending on cache)
6. **Artifact Upload** (~2-5 minutes)

### Cache Status Indicators
```
✓ Cache hit: openwrt-source-openwrt-24.10-abc123
✓ Cache hit: ccache-Linux-openwrt-24.10-def456
✓ Cache hit: downloads-openwrt-24.10-ghi789
```

## Troubleshooting

### Build Failures
1. **Out of Disk Space**:
   - Optimized disk cleanup should prevent this
   - If it occurs, enable cache cleaning

2. **Compilation Errors**:
   - Check if Mercury device support exists in the OpenWrt version
   - Try cleaning cache and rebuilding

3. **Missing Firmware Files**:
   - Check the "Organize files" step output
   - Verify device configuration is correct

### Cache Issues
1. **Stale Cache**:
   - Use "Clean build cache" option
   - Caches auto-expire after 7 days

2. **Cache Miss**:
   - Normal for first build or after config changes
   - Subsequent builds will be faster

## Best Practices

### For Development
1. Use incremental builds (don't clean cache)
2. Test config changes with SSH access enabled
3. Monitor ccache hit rates

### For Production
1. Clean cache for release builds
2. Verify all firmware files are generated
3. Test both sysupgrade and factory images

### For Maintenance
1. Regularly update workflow dependencies
2. Monitor disk usage and cache sizes
3. Clean old releases and artifacts

## Configuration Files

### Modified Files
- `.github/workflows/build-openwrt.yml`: Main workflow with optimizations
- `.config`: Device configuration for Mercury KM08-708H
- `diy-part1.sh`: Feed customizations
- `diy-part2.sh`: IP and hostname settings

### Key Settings
```yaml
env:
  UPLOAD_BIN_DIR: true      # Upload complete build
  UPLOAD_FIRMWARE: true     # Upload firmware files
  UPLOAD_RELEASE: true      # Create GitHub releases
```

## Expected Build Times

| Scenario | Time | Description |
|----------|------|-------------|
| First build | 1.5-2h | Cold cache, full compilation |
| Config change | 30-45m | Warm cache, partial recompilation |
| No changes | 15-30m | Full cache hit, minimal work |
| Clean build | 1.5-2h | Forced clean, no cache |

The optimized workflow provides significant time savings for iterative development while ensuring reliable firmware generation for the Mercury KM08-708H device.