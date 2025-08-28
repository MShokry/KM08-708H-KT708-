#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
# Customize default settings

# ========== IP Configuration ==========
# Set custom LAN IP address
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate

# Set custom hostname
sed -i 's/OpenWrt/KT708-Router/g' package/base-files/files/bin/config_generate

# Set custom subnet (optional)
# sed -i 's/192.168.1/192.168.10/g' package/base-files/files/bin/config_generate

# # ========== WiFi Configuration ==========
# # Create WiFi configuration file
# cat > package/base-files/files/etc/config/wireless << 'EOF'
# config wifi-device 'radio0'
#     option type 'mac80211'
#     option path 'pci0000:00/0000:00:01.0/0000:01:00.0'
#     option channel '6'
#     option band '2g'
#     option htmode 'HT40'
#     option country 'US'
#     option txpower '20'
#     option disabled '0'

# config wifi-iface 'default_radio0'
#     option device 'radio0'
#     option network 'lan'
#     option mode 'ap'
#     option ssid 'KT708-WiFi-2.4G'
#     option encryption 'psk2'
#     option key 'your_wifi_password_here'
#     option disabled '0'

# config wifi-device 'radio1'
#     option type 'mac80211'
#     option path 'pci0000:00/0000:00:01.0/0000:01:00.0+1'
#     option channel '36'
#     option band '5g'
#     option htmode 'VHT80'
#     option country 'US'
#     option txpower '23'
#     option disabled '0'

# config wifi-iface 'default_radio1'
#     option device 'radio1'
#     option network 'lan'
#     option mode 'ap'
#     option ssid 'KT708-WiFi-5G'
#     option encryption 'psk2'
#     option key 'your_wifi_password_here'
#     option disabled '0'
# EOF

# # ========== Network Configuration ==========
# # Create network configuration
# cat > package/base-files/files/etc/config/network << 'EOF'
# config interface 'loopback'
#     option proto 'static'
#     option ipaddr '127.0.0.1'
#     option netmask '255.0.0.0'

# config globals 'globals'
#     option ula_prefix 'fd12:3456:789a::/48'

# config interface 'lan'
#     option proto 'static'
#     option ipaddr '192.168.10.1'
#     option netmask '255.255.255.0'
#     option ip6assign '60'
#     option device 'br-lan'

# config device
#     option name 'br-lan'
#     option type 'bridge'
#     list ports 'eth0.1'
#     list ports 'eth0.2'
#     list ports 'eth0.3'
#     list ports 'eth0.4'

# config interface 'wan'
#     option proto 'dhcp'
#     option device 'eth0.2'

# config interface 'wan6'
#     option proto 'dhcpv6'
#     option device 'eth0.2'
# EOF

# # ========== DHCP Configuration ==========
# # Create DHCP configuration
# cat > package/base-files/files/etc/config/dhcp << 'EOF'
# config dnsmasq
#     option domainneeded '1'
#     option boguspriv '1'
#     option filterwin2k '0'
#     option localise_queries '1'
#     option rebind_protection '1'
#     option rebind_localhost '1'
#     option local '/lan/'
#     option domain 'lan'
#     option expandhosts '1'
#     option nonegcache '0'
#     option cachesize '1000'
#     option authoritative '1'
#     option readethers '1'
#     option leasefile '/tmp/dhcp.leases'
#     option resolvfile '/tmp/resolv.conf.d/resolv.conf.auto'
#     option nonwildcard '1'
#     option localservice '1'
#     option ednspacket_max '1232'

# config dhcp 'lan'
#     option interface 'lan'
#     option start '100'
#     option limit '150'
#     option leasetime '12h'
#     option dhcpv4 'server'
#     option dhcpv6 'server'
#     option ra 'server'
#     list ra_flags 'managed-config'
#     list ra_flags 'other-config'

# config dhcp 'wan'
#     option interface 'wan'
#     option ignore '1'
# EOF



# # Copy your custom configs ======
# cp custom-configs/wireless files/etc/config/
# cp custom-configs/network files/etc/config/
# cp custom-configs/dhcp files/etc/config/