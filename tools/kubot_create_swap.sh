#!/bin/bash

sudo mkdir /opt/image
cd /opt/image/
sudo touch swap
sudo dd if=/dev/zero of=/opt/image/swap bs=1024 count=2048000
sudo mkswap /opt/image/swap  
sudo swapon /opt/image/swap 

echo "add \"/opt/image/swap /swap swap defaults 0 0\" to \"/etc/fstab\" to make swap effecive"
# KUBOT2