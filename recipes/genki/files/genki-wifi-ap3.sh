#!/bin/bash

####################################
# Ganki Project
####################################
#
# Hotspot initialization script
# Author : Alaa-eddine KADDOURI
#
#
#
####################################
echo "====== Genki WiFi Init ====="

clean()
{
systemctl stop NetworkManager  
systemctl stop hostapd
systemctl stop dnsmasq

#ensure basic iptable rules
iptables -t nat -F
iptables -F

ifconfig wlan0 0 
}

setup()
{
ifconfig wlan0 up
ifconfig wlan0 10.0.1.1 netmask 255.255.255.0

#give some time for the interface to go up
sleep 1

#generate a WiFi random password
#sed -i.bak "s/^\(wpa_passphrase=\).*/\wpa_passphrase=$(openssl rand -hex 4)/" /etc/hostapd.conf

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
echo '1' > /proc/sys/net/ipv4/ip_forward


#sometimes hostapd fails to start it right after the above commands
sleep 1

systemctl start dnsmasq
systemctl start hostapd
}

clean
setup
