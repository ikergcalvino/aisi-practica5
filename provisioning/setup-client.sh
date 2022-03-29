#!/bin/bash
sed -i 's/XKBLAYOUT=\"us\"/XKBLAYOUT=\"es\"/g' /etc/default/keyboard
apt-get update
apt-get install -y ubuntu-desktop nfs-common cifs-utils smbclient nfs4-acl-tools nautilus-share seahorse-nautilus firefox gvfs-backends ntp filezilla
timedatectl set-timezone Europe/Madrid
systemctl enable ntp
systemctl start ntp
# This user has UID 1001
userdel ubuntu
shutdown -rf now
