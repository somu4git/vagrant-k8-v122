# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"

  # Kubernetes Master Server
  config.vm.define "kmaster" do |node|
  
    node.vm.box  = "generic/ubuntu2004"
    node.vm.hostname = "kmaster.example.com"
    node.vm.network "private_network", ip: "192.168.212.100"
    node.vm.synced_folder '.', '/vagrant'
    node.vm.provider :virtualbox do |v|
      v.name    = "kmaster"
      v.memory  = 4096
      v.cpus    =  2
     # v.gui     = true     
    end
  
    node.vm.provider :libvirt do |v|
      v.memory  = 4096
      v.nested  = true
      v.cpus    = 2
     # v.gui     = true
    end
  
   node.vm.provision "shell", path: "bootstrap_kmaster.sh"
  
  end
#end



  # Kubernetes Worker Nodes
  NodeCount = 2

  (1..NodeCount).each do |i|

    config.vm.define "kworker#{i}" do |node|

      node.vm.box = "generic/ubuntu2004"
      node.vm.hostname = "kworker#{i}.example.com"

      node.vm.network "private_network", ip: "192.168.212.10#{i}"
      node.vm.synced_folder ".", "/vagrant"
      node.vm.provider :virtualbox do |v|
        v.name    = "kworker#{i}"
        v.memory  = 2048
        v.cpus    = 2
        #v.gui     = true
      end

      node.vm.provider :libvirt do |v|
        v.memory  = 2048
        v.nested  = true
        v.cpus    = 2
        #v.gui     = true
      end

      node.vm.provision "shell", path: "bootstrap_kworker.sh"

    end

  end

end
