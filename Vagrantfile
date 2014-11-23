# -*- mode: ruby -*-
# vi: set ft=ruby :

# This requires Vagrant 1.7.0dev or newer (earlier versions can't reliably
# configure the centos network stack).
Vagrant.require_version ">= 1.6.5"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

FLOCKER_VMS=["flocker-1","flocker-2"]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", path: "centos/cloud-centos-7.sh"
  #config.vm.provision "shell", path: "docker-bootstrap.sh" # start etcd

  config.vm.box = "chef/centos-7.0"
  config.vm.box_version = "= 1.0.0"

  FLOCKER_VMS.each do |node_name|
    config.vm.define node_name do |flocker_node|
      flocker_node.vm.hostname = node_name
      flocker_node.vm.network "private_network", type: "dhcp"
    end
  end

end
