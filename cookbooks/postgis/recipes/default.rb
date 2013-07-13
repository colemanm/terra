install_prefix = "/usr/local"

["add-apt-repository 'http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main'", "apt-get update"].each do |cmd|
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

execute "Install PostGIS 2.0.3" do
  command <<-EOS
    if [ ! -d /usr/local/src/postgis-2.0.3 ]
    then
      cd /usr/local/src &&
      wget http://download.osgeo.org/postgis/source/postgis-2.0.3.tar.gz &&
      tar xfvz postgis-2.0.1.tar.gz &&
      cd postgis-2.0.1 &&
      ./configure &&
      make &&
      make install &&
      ldconfig &&
      make comments-install &&
      ln -sf /usr/share/postgresql-common/pg_wrapper /usr/local/bin/shp2pgsql &&
      ln -sf /usr/share/postgresql-common/pg_wrapper /usr/local/bin/pgsql2shp &&
      ln -sf /usr/share/postgresql-common/pg_wrapper /usr/local/bin/raster2pgsql &&
      curl -s https://raw.github.com/gist/c83798ee55a08b7a5de5/813a2ba7543697789d2b5af6fae2cabf547cef54/pg_hba.conf -o /etc/postgresql/9.1/main/pg_hba.conf &&
      curl -s https://raw.github.com/gist/bdf5accb7b328f7f596a/0f3a969132150655c861e2ea22852fdd16eac02c/postgresql.conf -o /etc/postgresql/9.1/main/postgresql.conf &&
      /etc/init.d/postgresql restart &&
      echo "CREATE ROLE vagrant LOGIN;"                  | psql -U postgres &&
      echo "CREATE DATABASE vagrant;"                    | psql -U postgres &&
      echo "ALTER USER vagrant SUPERUSER;"               | psql -U postgres &&
      echo "ALTER USER vagrant WITH PASSWORD 'vagrant';" | psql -U postgres &&
      echo "CREATE DATABASE template_postgis;"           | psql -U postgres &&
      echo "CREATE EXTENSION postgis;"                   | psql -U postgres -d template_postgis &&
      echo "CREATE EXTENSION postgis_topology;"          | psql -U postgres -d template_postgis &&
      echo "GRANT ALL ON geometry_columns TO PUBLIC;"    | psql -U postgres -d template_postgis &&
      echo "GRANT ALL ON spatial_ref_sys TO PUBLIC;"     | psql -U postgres -d template_postgis
    fi
  EOS
  action :run
  user 'root'
end
