%w[wget curl zip ack python-software-properties autoconf bison flex libyaml-dev libtool make vim git subversion openjdk-7-jdk swig build-essential].each do |pkg|
  package pkg do
    action :install
  end
end

install_prefix = "/usr/local"

["add-apt-repository ppa:ubuntugis/ubuntugis-unstable -y", "apt-get update"].each do |cmd|
  execute cmd do
    user "root"
  end
end

["add-apt-repository ppa:gophers/go -y", "apt-get update"].each do |cmd|
  execute cmd do
    user "root"
  end
end

# Mapnik 2.2
["add-apt-repository ppa:mapnik/v2.2.0 -y", "apt-get update"].each do |cmd|
  execute cmd do
    user "root"
  end
end

%w[libmapnik mapnik-utils python-mapnik].each do |pkg|
  package pkg do
    action :install
  end
end

# Geo base packages + tools
%w[
  libpng12-dev
  libjpeg-dev
  libgif-dev
  liblzma-dev
  libxml2-dev
  libsqlite3-dev
  libproj-dev
  libgeos-dev
  libspatialite-dev
  libgeotiff-dev
  libgdal-dev
  libpoppler-dev
  libleveldb-dev
  python-dev
  python-pip
  python-gdal
  ruby-dev
  libgdal-ruby
  libjson0-dev
  gpsbabel
  imagemagick
  openjdk-7-jdk
  golang-stable
].each do |pkg|
  package pkg do
    action :install
  end
end

directory "/home/#{node[:user]}/local" do
  owner node[:user]
  group node[:user]
  mode 0755
  action :create
end

# Install ry
git "ry" do
  repository "git://github.com/zhm/ry.git"
  reference 'master'
  destination "#{install_prefix}/src/ry"
  action :checkout
  user "root"
end

ENV['RY_PREFIX'] = install_prefix

execute "Install ry" do
  cwd "#{install_prefix}/src/ry"
  command <<-EOS
    [ -x #{install_prefix}/bin/ry ] || PREFIX=#{install_prefix} make install
  EOS
  action :run
  user "root"
end

execute "Install Ruby 1.9.3" do
  command <<-EOS
    [ -x #{install_prefix}/lib/ry/current/bin/ruby ] ||
    #{install_prefix}/bin/ry install https://github.com/ruby/ruby/tarball/v1_9_3_195 1.9.3 --enable-shared=yes
  EOS
  action :run
  user "root"
end

execute "Setup Ruby" do
  command <<-EOS
    if [ ! -x #{install_prefix}/lib/ry/current/bin/ruby ]; then
      export RY_PREFIX=#{install_prefix} &&
      export PATH=$RY_PREFIX/lib/ry/current/bin:$PATH &&
      #{install_prefix}/lib/ry/current/bin/gem update --system &&
      #{install_prefix}/lib/ry/current/bin/gem install bundler
    fi
  EOS
  action :run
  user "root"
end

git "oh-my-zsh" do
  repository "git://github.com/robbyrussell/oh-my-zsh.git"
  reference 'master'
  destination "/home/#{node[:user]}/.oh-my-zsh"
  action :checkout
  user node[:user]
end

template "/home/" + node[:user] + "/.zshrc" do
  source "terra.zshrc.erb"
  mode 0644
  owner node[:user]
  group node[:user]
end

template "/home/" + node[:user] + "/.oh-my-zsh/themes/terra.zsh-theme" do
  source "terra.zsh-theme.erb"
  mode 0644
  owner node[:user]
  group node[:user]
end

execute "Set shell to zsh" do
  command "usermod -s /bin/zsh #{node[:user]}"
  action :run
  user "root"
end

git "n" do
  repository "git://github.com/zhm/n.git"
  reference 'master'
  destination "#{install_prefix}/src/n"
  action :checkout
  user "root"
end

execute "Install n" do
  cwd "#{install_prefix}/src/n"
  command <<-EOS
    make install && n 0.8.9
  EOS
  action :run
  user 'root'
end

execute "Install standard node modules" do
  modules = %w(coffee-script underscore node-gyp)
  command modules.map {|m| "npm install -g #{m}" }.join(' && ')
  action :run
  user 'root'
end

file "/etc/hostname" do
  content "terra\n"
end

service "hostname" do
  action :restart
end

file "/etc/hosts" do
  content "127.0.0.1 localhost terra\n"
end
