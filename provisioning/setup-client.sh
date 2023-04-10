#!/bin/bash

sed -i 's/XKBLAYOUT=\"us\"/XKBLAYOUT=\"es\"/g' /etc/default/keyboard

if [ ! -f /etc/apt/sources.list.bak ]; then
	cp /etc/apt/sources.list /etc/apt/sources.list.bak
	rm /etc/apt/sources.list
fi

cp /vagrant/provisioning/sources.list /etc/apt

# Install Vbox guest additions
sh /vagrant/provisioning/install-vbguest.sh

apt-get update
apt-get install -y ubuntu-desktop nfs-common cifs-utils smbclient nfs4-acl-tools nautilus-share seahorse-nautilus firefox gvfs-backends ntp filezilla
timedatectl set-timezone Europe/Madrid
systemctl enable ntp
systemctl start ntp
# This user has UID 1001
userdel ubuntu >& /dev/null

echo "Restart client VM executing 'vagrant halt client' and then 'vagrant up client'"
