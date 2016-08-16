# -*- mode: ruby -*-
# vi: set ft=ruby :

required_plugins = [ 'vagrant-vbguest', 'vagrant-cachier', 'vagrant-puppet-install']

required_plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    system("vagrant plugin install #{plugin}")
  end
end

hosts = [
  {name: 'prod', hostname: 'vm-rec-prod-app.kainos.com', ip: '10.10.10.10', environment: 'production', cpu: '2', mem: '4096', port_forward: [{guest: 80, host: 8080}, {guest: 8888, host: 8888}, {guest: 5432, host: 5432}]},
  ]

Vagrant.configure("2") do |config|
  hosts.each do |host|
    config.vm.box = "geerlingguy/centos7"
    config.vm.box_check_update = true
    config.vbguest.auto_update = true
    config.cache.scope = :box
    config.puppet_install.puppet_version = "4.5.3"
    config.vm.define host[:name] do |vm_config|
      vm_config.vm.hostname = host[:hostname]
      vm_config.vm.network :private_network, ip: host[:ip]
      vm_config.vm.synced_folder "puppet/modules/", "/etc/puppetlabs/code/modules"
      vm_config.vm.provider "virtualbox" do |vbox|
        vbox.name = "#{vm_config.vm.hostname}"
        vbox.customize ["modifyvm", :id, "--memory", "#{host[:mem]}"]
        vbox.customize ["modifyvm", :id, "--cpus", "#{host[:cpu]}"]
        vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
      if !host[:port_forward].empty? then
        host[:port_forward].each do |forward_rule|
          vm_config.vm.network "forwarded_port", guest: forward_rule[:guest], host: forward_rule[:host], auto_correct: true
        end
      end
      vm_config.vm.provision "puppet" do |puppet|
        puppet.environment_path = "puppet/environments"
        puppet.environment = "#{host[:environment]}"
        puppet.facter = {
          "vagrant" => "1"
        }
      end
    end
  end
end
