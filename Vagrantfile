# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Base box for all VMs
  config.vm.box = "generic/ubuntu2204"
  
  # Web Server VM
  config.vm.define "web" do |web|
    web.vm.hostname = "web-server"
    web.vm.network "private_network", ip: "192.168.20.100"
    web.vm.network "forwarded_port", guest: 3000, host: 3001  # Web app
    web.vm.synced_folder "./app", "/var/www/webapp"
    web.vm.provision "shell", path: "scripts/web-setup.sh"
    web.vm.provider "libvirt" do |lv|
      lv.memory = 1024
      lv.cpus = 1
      lv.storage_pool_name = "default"
    end
  end

  # Database VM  
  config.vm.define "db" do |db|
    db.vm.hostname = "database"
    db.vm.network "private_network", ip: "192.168.20.101"
    db.vm.provision "shell", path: "scripts/db-setup.sh"
    db.vm.provider "libvirt" do |lv|
      lv.memory = 1024
      lv.cpus = 1
      lv.storage_pool_name = "default"
    end
  end

  # Monitoring VM
  config.vm.define "monitoring" do |monitoring|
    monitoring.vm.hostname = "monitoring"
    monitoring.vm.network "private_network", ip: "192.168.20.102"
    monitoring.vm.network "forwarded_port", guest: 3000, host: 3000  # Grafana
    monitoring.vm.network "forwarded_port", guest: 9090, host: 9090  # Prometheus
    monitoring.vm.synced_folder "./config", "/vagrant/config"
    monitoring.vm.provision "shell", path: "scripts/monitoring-setup.sh"
    monitoring.vm.provider "libvirt" do |lv|
      lv.memory = 1024
      lv.cpus = 1
      lv.storage_pool_name = "default"
    end
  end
end
