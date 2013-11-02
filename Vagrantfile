require 'json'

Vagrant.configure("2") do |config|

  config.vm.hostname = 'terra'
  config.vm.box = "precise"
  config.berkshelf.enabled = true
  config.vm.synced_folder "data", "/home/vagrant/data/"
  # Add custom synced folders here
  # config.vm.synced_folder "/path/to/dir", "/home/vagrant/dir"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end

  json = JSON.parse(File.open("terra.json").read)

  config.vm.provision :chef_solo do |chef|
    json["run_list"].each do |recipe|
      chef.add_recipe recipe
    end
    chef.json = { user: "vagrant" }
  end

end
