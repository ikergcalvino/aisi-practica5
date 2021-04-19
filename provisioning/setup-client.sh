#!/bin/bash

sed -i 's/XKBLAYOUT=\"us\"/XKBLAYOUT=\"es\"/g' /etc/default/keyboard
apt-get update
apt-get install -y --no-install-recommends ubuntu-desktop
apt-get install -y nfs-common cifs-utils smbclient nfs4-acl-tools nautilus-share seahorse-nautilus firefox gvfs-backends ntp filezilla
timedatectl set-timezone Europe/Madrid
systemctl enable ntp
systemctl start ntp
shutdown -rf now
