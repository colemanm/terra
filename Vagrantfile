require 'json'

Vagrant.configure("2") do |config|

  config.vm.hostname = 'terra'
  config.vm.box = "precise"
  config.vm.synced_folder "data", "/home/vagrant/data/"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      "recipe[apt]",
      "recipe[zsh]",
      "recipe[environment]",
      "recipe[gdal]",
      "recipe[postgis]",
      "recipe[tilemill]"
    ]
    chef.json = { user: "vagrant" }
  end

end
