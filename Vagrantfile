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

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision :chef_solo do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

end
