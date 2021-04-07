#! /bin/bash

nmcli con add type wifi ifname wlan0 mode ap con-name kubot_ap ssid kubot
nmcli con modify kubot_ap 802-11-wireless.band bg
nmcli con modify kubot_ap 802-11-wireless.channel 1
nmcli con modify kubot_ap 802-11-wireless-security.key-mgmt wpa-psk
nmcli con modify kubot_ap 802-11-wireless-security.proto rsn
nmcli con modify kubot_ap 802-11-wireless-security.group ccmp
nmcli con modify kubot_ap 802-11-wireless-security.pairwise ccmp
nmcli con modify kubot_ap 802-11-wireless-security.psk kubot_ap
nmcli con modify kubot_ap ipv4.addr 192.168.5.1/24
nmcli con modify kubot_ap ipv4.method shared
nmcli con up kubot_ap
