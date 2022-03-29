# -*- mode: ruby -*-
# vi: set ft=ruby :
require_relative 'provisioning/vbox.rb'
VBoxUtils.check_version('6.1.32')
Vagrant.require_version ">= 2.2.19"

# OMV hostname limited to 15 characters when using SMB/CIFS
OMV_HOSTNAME = "xxx-aisi2122"
CLIENT_HOSTNAME = "xxx-aisi2122-cli"

Vagrant.configure("2") do |config|
  # Configure hostmanager plugin
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  config.vm.define "omv", primary: true do |omv|
    omv.vm.box = "debian/bullseye64"
    omv.vm.box_version = "11.20211230.1"
    omv.vm.box_check_update = false
    omv.vm.hostname = OMV_HOSTNAME
    omv.vm.network "private_network", ip: "192.172.16.25", virtualbox__intnet: true
    omv.vm.network "forwarded_port", guest: 80, host: 9090
    omv.vm.synced_folder ".", "/vagrant", type: "virtualbox"

    omv.vm.provider :virtualbox do |prov|
      prov.gui = false
      prov.name = "AISI-P5-OMV"
      prov.cpus = 2
      prov.memory = 2048

      # Add disks
      for i in 0..2 do
        filename = "./disks/disk#{i}.vdi"
          unless File.exist?(filename)
            prov.customize ["createmedium", "disk", "--filename", filename, "--format", "vdi", "--size", 10 * 1024]
          end
	  prov.customize ["storageattach", :id, "--storagectl","SATA Controller", "--port", i + 1, "--device", 0, "--type", "hdd", "--medium", filename]
      end
    end

    omv.vm.provision "shell", path: "provisioning/install-omv.sh"
  end

  config.vm.define "client" do |client|
    client.vm.box = "ubuntu/focal64"
    client.vm.box_version = "20220322.0.0"
    client.vm.box_check_update = false
    client.vm.hostname = CLIENT_HOSTNAME
    client.vm.network "private_network", ip: "192.172.16.30", virtualbox__intnet: true
    client.vm.synced_folder ".", "/vagrant", type: "virtualbox"

    client.vm.provider "virtualbox" do |prov|
      prov.gui = true
      prov.name = "AISI-P5-client"
      prov.cpus = 1
      prov.memory = 2048
    end

    client.vm.provision "shell", path: "provisioning/setup-client.sh"
  end
end
