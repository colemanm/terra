src = "/home/#{node[:user]}/local"

git "ogrtool" do
  repository "git@github.com:colemanm/ogrtool.git"
  reference "master"
  destination "#{src}"
  action :checkout
  user node[:user]
end

git "gazetteer" do
  repository "git@github.com:colemanm/gazetteer.git"
  reference "master"
  destination "#{src}"
  action :checkout
  user node[:user]
end

template "/home/" + node[:user] + "/.postgres" do
  source "postgres.yml.erb"
  mode 0744
  owner node[:user]
  group node[:user]
end
