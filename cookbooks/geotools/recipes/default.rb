src_path = "/usr/local/src"

git "ogrtool" do
  repository "https://github.com/colemanm/ogrtool.git"
  reference "master"
  destination "#{src_path}/ogrtool"
  action :checkout
  user "root"
end

execute "install ogrtool" do
  command <<-EOS
    cd #{src_path}/ogrtool
    make
  EOS
  action :run
  user node[:user]
end

git "gazetteer" do
  repository "https://github.com/colemanm/gazetteer.git"
  reference "master"
  destination "#{src_path}/gazetteer"
  action :checkout
  user "root"
end

execute "install gazetteer" do
  command <<-EOS
    cd #{src_path}/gazetteer
    make
  EOS
  action :run
  user node[:user]
end

template "/home/" + node[:user] + "/.postgres" do
  source "postgres.yml.erb"
  mode 0600
  owner node[:user]
  group node[:user]
end
