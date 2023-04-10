#!/bin/sh

VERSION=7.0.6

if [ ! -f /tmp/VBoxGuestAdditions_$VERSION.iso ]; then
	apt-get update
	apt-get --yes install linux-headers-$(uname -r) build-essential dkms libxt6 libxmu-dev libxt-dev
	wget https://download.virtualbox.org/virtualbox/$VERSION/VBoxGuestAdditions_$VERSION.iso
	mv VBoxGuestAdditions_$VERSION.iso /tmp
	mkdir /mnt/VBoxGuestAdditions
	mount -o loop,ro /tmp/VBoxGuestAdditions_$VERSION.iso /mnt/VBoxGuestAdditions

	if [ ! -f /usr/sbin/vbox-uninstall-guest-additions ]; then
		sh /mnt/VBoxGuestAdditions/VBoxLinuxAdditions.run uninstall --force
	else
		/usr/sbin/vbox-uninstall-guest-additions
	fi

	sh /mnt/VBoxGuestAdditions/VBoxLinuxAdditions.run
	umount /mnt/VBoxGuestAdditions
	rmdir /mnt/VBoxGuestAdditions
else
	echo "No update is needed"
fi
