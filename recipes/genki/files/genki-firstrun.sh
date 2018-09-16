#!/bin/bash

# 1. set volume to appropriate value
i2cset -y 0 0x4b 0x30

# 2. fix the mac address of eth0
macaddre=$(cat /sys/class/net/eth0/address)
cat <<EOF > /etc/systemd/network/20-eth0-mac.link
[Match]
Driver=smsc75xx

[Link]
Name=eth0
MACAddress=${macaddre}
EOF

macaddrw=$(cat /sys/class/net/wlan0/address)
cat <<EOF > /etc/systemd/network/21-wlan0-mac.link
[Match]
Driver=wcn36xx

[Link]
Name=wlan0
MACAddress=${macaddrw}
EOF


# X. Disable it self
systemctl disable genki-firstrun.service
