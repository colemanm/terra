require 'json'

Vagrant::Config.run do |config|

  config.vm.box = "precise"
  config.vm.customize ["modifyvm", :id, "--memory", 1024]

  config.vm.forward_port 80, 80

  json = JSON.parse(File.open("terra.json").read)

  config.vm.provision :chef_solo do |chef|
    json["run_list"].each do |recipe|
      chef.add_recipe recipe
    end
    chef.json = { user: "vagrant" }
  end

end
