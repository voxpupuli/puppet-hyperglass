# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Environment variables may be used to control the behavior of the Vagrant VM's
# defined in this file. This is intended as a special-purpose affordance and
# should not be necessary in normal situations. If there is a need to run
# multiple backend instances simultaneously, avoid the IP conflict by setting
# the ALTERNATE_IP environment variable:
#
#     ALTERNATE_IP=192.168.52.9 vagrant up hyperglass-server
#
# NOTE: The agent VM instances assume the backend VM is accessible on the
# default IP address, therefore using an ALTERNATE_IP is not expected to behave
# well with agent instances.
if not Vagrant.has_plugin?('vagrant-vbguest')
  abort <<-EOM

vagrant plugin vagrant-vbguest >= 0.16.0 is required.
https://github.com/dotless-de/vagrant-vbguest
To install the plugin, please run, 'vagrant plugin install vagrant-vbguest'.

  EOM
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.define "hyperglass-server", primary: true, autostart: true do |c|
    c.vm.box = "centos/7"
    c.vm.hostname = 'hyperglass-server.example.com'
    c.vm.network :private_network, ip: ENV['ALTERNATE_IP'] || '192.168.73.10'
    c.vm.network :forwarded_port, guest: 8001, host: 8001, auto_correct: true
    c.vm.provision :shell, :path => "vagrant/provision_basic_el.sh"
    c.vm.provision :shell, :inline => "puppet apply /vagrant/vagrant/server.pp"
  end

  config.vm.define "el7-agent", primary: true, autostart: true do |c|
    c.vm.box = "centos/7"
    c.vm.hostname = 'el7-agent.example.com'
    c.vm.network :private_network, ip: ENV['ALTERNATE_IP'] || '192.168.73.20'
    c.vm.network :forwarded_port, guest: 8080, host: 8080, auto_correct: true
    c.vm.provision :shell, :path => "vagrant/provision_basic_el.sh"
    c.vm.provision :shell, :inline => "puppet apply /vagrant/vagrant/agent.pp"
  end
end
