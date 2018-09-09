#!/bin/bash

# 1. set volume to appropriate value
i2cset -y 0 0x4b 0x30

# 2. fix the mac address of eth0
macaddr=$(cat /sys/class/net/eth0/address)
echo <<EOF > /etc/systemd/network/20-eth0-mac.link 
[Match]
Driver=smsc75xx

[Link]
Name=eth0
MACAddress=${macaddr}
EOF


# X. Disable it self
systemctl disable genki-firstrun.service
