src_path      = "/usr/local/src"

postgis_path  = "http://download.osgeo.org/postgis/source/postgis-2.0.3.tar.gz"
postgis       = "postgis-2.0.3.tar.gz"

install_prefix = "/usr/local"

["add-apt-repository ppa:pitti/postgresql -y", "apt-get update"].each do |cmd|
  execute cmd do
    user "root"
  end
end

%w[
  postgresql-9.2
  postgresql-server-dev-9.2
  postgresql-plpython-9.2
  postgresql-contrib-9.2
  libpq-dev
].each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{Chef::Config['file_cache_path']}/postgis-2.0.3.tar.gz" do
  source "#{postgis_path}"
  action :create_if_missing
  not_if { ::File.exists?("#{Chef::Config['file_cache_path']}/postgis-2.0.3.tar.gz")}
end

execute "Extract PostGIS" do
  command <<-EOS
    cd #{Chef::Config['file_cache_path']}

    if [ ! -d "#{src_path}/postgis" ]; then
      mkdir -p #{src_path}/postgis
      tar xzf #{postgis} --strip 1 -C #{src_path}/postgis
    fi
  EOS
  action :run
  user "root"
end

template node["postgis"]["conf_path"] + "/postgresql.conf" do
  source "postgres.conf.erb"
  mode 0744
  owner "postgres"
  group "postgres"
end

template node["postgis"]["conf_path"] + "/pg_hba.conf" do
  source "pg_hba.conf.erb"
  mode 0744
  owner "postgres"
  group "postgres"
end

execute "Install PostGIS 2.0.3" do
  command <<-EOS
    if [ ! -d /usr/share/postgresql/9.2/contrib/postgis-2.0 ]; then
      cd #{src_path}/postgis
      ./configure
      make
      make install
      ldconfig
      make comments-install
      ln -sf /usr/share/postgresql-common/pg_wrapper /usr/local/bin/shp2pgsql
      ln -sf /usr/share/postgresql-common/pg_wrapper /usr/local/bin/pgsql2shp
      ln -sf /usr/share/postgresql-common/pg_wrapper /usr/local/bin/raster2pgsql
      /etc/init.d/postgresql restart
    fi
  EOS
  action :run
  user "root"
end

execute "Create roles and databases" do
  command <<-EOS
    echo "CREATE DATABASE template_postgis;"           | psql -U postgres
    echo "CREATE EXTENSION postgis;"                   | psql -U postgres -d template_postgis
    echo "CREATE EXTENSION postgis_topology;"          | psql -U postgres -d template_postgis
    echo "GRANT ALL ON geometry_columns TO PUBLIC;"    | psql -U postgres -d template_postgis
    echo "GRANT ALL ON spatial_ref_sys TO PUBLIC;"     | psql -U postgres -d template_postgis
  EOS
  action :run
  user "root"
end
