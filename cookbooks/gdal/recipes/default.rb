
execute "Download GDAL" do
  command <<-EOS
    cd /usr/local/src &&
    wget http://download.osgeo.org/gdal/1.10.0/gdal-1.10.0.tar.gz &&
    tar xvzf gdal-1.10.0.tar.gz
  EOS
  action :run
  user "root"
end

execute "Download MDB resources" do
  command <<-EOS
    cd /usr/local/src &&
    wget http://mdb-sqlite.googlecode.com/files/mdb-sqlite-1.0.2.tar.bz2
    tar xvf mdb-sqlite-1.0.2.tar.bz2 --strip 1 -C mdb-sqlite
    rm mdb-sqlite-1.0.2.tar.bz2
  EOS
  action :run
  user "root"
end