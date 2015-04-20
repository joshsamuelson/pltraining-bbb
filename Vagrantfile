# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "4096"
    v.vmx["numvcpus"] = "2"
  end

  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
  config.vm.synced_folder ".", "/etc/puppet/modules/bbb"

  config.vm.provision "shell", inline: 'puppet module install puppetlabs/apt'
  config.vm.provision "shell", inline: 'puppet apply -e "include bbb"'
end
