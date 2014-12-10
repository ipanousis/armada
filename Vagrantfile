# -*- mode: ruby -*-
# vi: set ft=ruby :

# This requires Vagrant 1.7.0dev or newer (earlier versions can't reliably
# configure the centos network stack).
Vagrant.require_version ">= 1.6.5"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

FLOCKER_VMS=["flocker-nimbus-1","flocker-nimbus-2"]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  FLOCKER_VMS.each do |node_name|
    config.vm.define node_name do |node|

      node.vm.hostname = node_name
      
      #node.vm.box = "chef/centos-7.0" # for virtualbox
      #node.vm.box = "gce"             # for google
      #node.vm.box = nil               # for docker

      node.vm.synced_folder "./", "/vagrant", disabled: true

      node.vm.provider :virtualbox do |vb, override|
        override.vm.box = "chef/centos-7.0"
        override.vm.box_version = "= 1.0.0"
        override.vm.network "private_network", type: "dhcp"
      end

      node.vm.provider :google do |google, override|

        override.ssh.pty = true
        override.ssh.username = "ypanousi" # YOUR LOCAL USERNAME
        override.ssh.private_key_path = "/home/ypanousi/.ssh/google_compute_engine" # YOUR GCE PRIVATE SSH KEY

        google.google_project_id = "oceanic-cache-718" # YOUR GCE PROJECT ID
        google.google_client_email = "137500756124-el23ub9qhimvbm48tbfdoheqhmmgtr5d@developer.gserviceaccount.com" # YOUR GCE SERVICE ACCOUNT EMAIL
        google.google_key_location = "/home/ypanousi/projects/armada/elastic-search-f96b11d24423.p12" # YOUR GCE SERVICE ACCOUNT KEY

        google.zone = "europe-west1-a"
        google.zone_config "europe-west1-a" do |zone1a|
            zone1a.name = node_name
            zone1a.image = "centos-7-v20141108"
            zone1a.machine_type = "n1-highcpu-8"
            zone1a.zone = "europe-west1-a"
        end
      end

      # flocker installation fails on docker so far, due to systemd
      node.vm.provider :docker do |d, override|
        override.vm.box = nil
        override.ssh.username = "root"
        override.ssh.password = "kattlefish"
        d.image = "vagrant-centos7"
        d.privileged = true
        d.has_ssh = true
      end

      node.vm.provision "shell", path: "centos/cloud-centos-7.sh"

    end
  end

end
