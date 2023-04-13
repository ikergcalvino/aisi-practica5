# -*- mode: ruby -*-
# vi: set ft=ruby :
require_relative 'provisioning/vbox.rb'
VBoxUtils.check_version('7.0.6')
Vagrant.require_version ">= 2.3.4"

class VagrantPlugins::ProviderVirtualBox::Action::Network
  def dhcp_server_matches_config?(dhcp_server, config)
    true
  end
end

CLIENT_HOSTNAME = "idc-aisi2223-cli"

Vagrant.configure("2") do |config|
  # Configure hostmanager and vbguest plugins
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.vbguest.auto_update = false

  config.vm.define "omv", primary: true do |omv|
    omv.vm.box = "rreye/omv6"
    omv.vm.box_version = "1.0"
    omv.vm.box_check_update = false
    omv.vm.hostname = "omv-server"
    omv.vm.network "private_network", ip: "192.172.16.25", virtualbox__intnet: true
    omv.vm.network "forwarded_port", guest: 80, host: 9090
    omv.vm.synced_folder ".", "/vagrant", type: "virtualbox"

    omv.vm.provider "virtualbox" do |prov|
      prov.gui = false
      prov.name = "AISI-P5-OMV"
      prov.cpus = 2
      prov.memory = 2048

      # Add disks
      for i in 0..2 do
        disk = "./disks/disk#{i}.vdi"
        unless File.exist?(disk)
          prov.customize ["createmedium", "disk", "--filename", disk, "--format", "VDI", "--size", 10 * 1024]
        end
        prov.customize ["storageattach", :id, "--storagectl","SATA Controller", "--port", i + 1, "--device", 0, "--type", "hdd", "--medium", disk]
      end
    end
  end

  config.vm.define "client" do |client|
    client.vm.box = "ubuntu/focal64"
    client.vm.box_version = "20230110.0.0"
    #client.vm.box = "ubuntu/bionic64"
    #client.vm.box_version = "20230131.0.0"
    client.vm.box_check_update = false
    client.vm.hostname = CLIENT_HOSTNAME
    client.vm.network "private_network", ip: "192.172.16.30", virtualbox__intnet: true
    client.vm.synced_folder ".", "/vagrant", type: "virtualbox"

    client.vm.provider "virtualbox" do |prov|
      prov.gui = true
      prov.name = "AISI-P5-Client"
      prov.cpus = 2
      prov.memory = 2048
    end

    client.vm.provision "shell", run: "once", path: "provisioning/setup-client.sh"
  end
end
