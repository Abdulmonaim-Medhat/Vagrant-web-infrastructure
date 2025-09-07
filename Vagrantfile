Vagrant.configure("2") do |config|
  # Base box for all VMs
  config.vm.box = "generic/ubuntu2204"
  
  # Web Server VM
  config.vm.define "web" do |web|
    web.vm.hostname = "web-server"
    web.vm.network "private_network", ip: "192.168.20.100"
    web.vm.synced_folder "./app", "/var/www/webapp"
    # we can use rsync here for better performance
    # web.vm.synced_folder "./app", "/var/www/webapp", type: "rsync"
    # in a terminal run "vagrant rsync web"
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

  # Load Balancer VM
  config.vm.define "lb" do |lb|
    lb.vm.hostname = "load-balancer"
    lb.vm.network "private_network", ip: "192.168.20.102"
    lb.vm.network "forwarded_port", guest: 80, host: 8080
    lb.vm.provider "libvirt" do |lv|
      lv.memory = 512
      lv.cpus = 1
      lv.storage_pool_name = "default"
    end
  end
end
