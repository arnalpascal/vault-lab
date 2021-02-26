Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "vault", primary: true do |v|
    v.vm.box = "fedora/33-cloud-base"
    v.vm.box_check_update = true
    v.vm.hostname = "vault"

    v.vm.synced_folder "./vault", "/vagrant", type: "rsync"

    v.vm.network :private_network, :ip => '172.28.128.200'
 
    v.vm.provider :libvirt do |p|
      p.cpus = 2 
      p.memory = 2048
      p.nested = true
      p.graphics_type = "none"
    end

    v.vm.provision :ansible do |ansible|
      ansible.playbook = "provisioning/playbook.yaml"
      ansible.inventory_path= "provisioning/inventory.yaml"
    end

  end
end
