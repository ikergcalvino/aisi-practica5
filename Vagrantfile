# -*- mode: ruby -*-
# vi: set ft=ruby :

# Max. 15 characters for OMV hostname
omv_hostname = "xxx-aisi2021"
client_hostname = "xxx-aisi2021-client"

Vagrant.configure("2") do |config|
  # Configure hostmanager plugin
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false

  config.vm.define "omv" do |omv|
    omv.vm.box = "debian/buster64"
    omv.vm.hostname = omv_hostname
    omv.vm.define omv_hostname
    omv.vm.network "private_network", ip: "192.172.16.25"
    omv.vm.synced_folder ".", "/vagrant", type: "virtualbox"

    omv.vm.provider :virtualbox do |prov|
      prov.name = omv_hostname
      prov.cpus = 1
      prov.memory = 2048

      # Add disks
      for i in 0..2 do
        filename = "./disks/disk#{i}.vmdk"
          unless File.exist?(filename)
            prov.customize ["createmedium", "disk", "--filename", filename, "--size", 10 * 1024]
            prov.customize ["storageattach", :id, "--storagectl","SATA Controller", "--port", i + 1, "--device", 0, "--type", "hdd", "--medium", filename]
          end
      end
    end

    omv.vm.provision "shell", path: "provisioning/install-omv.sh"
  end

  config.vm.define "client" do |client|
    client.vm.box = "hashicorp/bionic64"
    client.vm.hostname = client_hostname
    client.vm.define client_hostname
    client.vm.network "private_network", ip: "192.172.16.30"
    client.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
    client.vm.synced_folder ".", "/vagrant", type: "virtualbox"

    client.vm.provider "virtualbox" do |prov|
      prov.gui = true
      prov.name = client_hostname
      prov.cpus = 1
      prov.memory = 2048
    end

    client.vm.provision "shell", path: "provisioning/setup-client.sh"
  end
end
