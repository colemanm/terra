s3_path       = "https://terra-libs.s3.amazonaws.com"
gdal_path     = "http://download.osgeo.org/gdal/1.10.0/gdal-1.10.0.tar.gz"
src_path      = "/usr/local/src"

sdk_gdal      = "gdal-1.10.0.tar.gz"
sdk_filegdb   = "FileGDB_API_1_2-64.tar.gz"
sdk_mrsid     = "MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44.tar.gz"
sdk_kml       = "install-libkml-r864-64bit.tar.gz"
sdk_ecw       = "install-libecwj2-ubuntu12.04-64bit.tar.gz"
sdk_openjpeg  = "install-openjpeg-2.0.0-ubuntu12.04-64bit.tar.gz"
sdk_mdb       = "mdb-sqlite-1.0.2.tar.bz2"

remote_file "#{Chef::Config["file_cache_path"]}/gdal-1.10.0.tar.gz" do
  source "#{gdal_path}"
  action :create_if_missing
  not_if { ::File.exists?("#{Chef::Config['file_cache_path']}/gdal-1.10.0.tar.gz")}
end

remote_file "#{Chef::Config['file_cache_path']}/#{sdk_filegdb}" do
  source "#{s3_path}/#{sdk_filegdb}"
  action :create_if_missing
  not_if { ::File.exists?("#{Chef::Config['file_cache_path']}/#{sdk_filegdb}") }
end

remote_file "#{Chef::Config['file_cache_path']}/#{sdk_mrsid}" do
  source "#{s3_path}/#{sdk_mrsid}"
  action :create_if_missing
  not_if { ::File.exists?("#{Chef::Config['file_cache_path']}/#{sdk_mrsid}") }
end

remote_file "#{Chef::Config['file_cache_path']}/#{sdk_kml}" do
  source "#{s3_path}/#{sdk_kml}"
  action :create_if_missing
  not_if { ::File.exists?("#{Chef::Config['file_cache_path']}/#{sdk_kml}") }
end

remote_file "#{Chef::Config['file_cache_path']}/#{sdk_ecw}" do
  source "#{s3_path}/#{sdk_ecw}"
  action :create_if_missing
  not_if { ::File.exists?("#{Chef::Config['file_cache_path']}/#{sdk_ecw}") }
end

remote_file "#{Chef::Config['file_cache_path']}/#{sdk_openjpeg}" do
  source "#{s3_path}/#{sdk_openjpeg}"
  action :create_if_missing
  not_if { ::File.exists?("#{Chef::Config['file_cache_path']}/#{sdk_openjpeg}") }
end

remote_file "#{Chef::Config['file_cache_path']}/#{sdk_mdb}" do
  source "#{s3_path}/#{sdk_mdb}"
  action :create_if_missing
  not_if { ::File.exists?("#{Chef::Config['file_cache_path']}/#{sdk_mdb}") }
end

execute "Extract libs" do
  command <<-EOS
    cd #{Chef::Config['file_cache_path']}

    if [ ! -d "#{src_path}/gdal" ]; then
      mkdir -p #{src_path}/gdal
      tar xzf #{sdk_gdal} --strip 1 -C #{src_path}/gdal
    fi

    if [ ! -d "#{src_path}/filegdb" ]; then
      mkdir -p #{src_path}/filegdb
      tar xzf #{sdk_filegdb} --strip 1 -C #{src_path}/filegdb
      cp -r #{src_path}/filegdb/include/* /usr/local/include
      cp -r #{src_path}/filegdb/lib/* /usr/local/lib
    fi

    if [ ! -d "#{src_path}/mrsid" ]; then
      mkdir -p #{src_path}/mrsid
      tar xzf #{sdk_mrsid} --strip 1 -C #{src_path}/mrsid
      cp -r #{src_path}/mrsid/Raster_DSDK/include/* /usr/local/include
      cp -r #{src_path}/mrsid/Raster_DSDK/lib/* /usr/local/lib
      cp -r #{src_path}/mrsid/Lidar_DSDK/include/* /usr/local/include
      cp -r #{src_path}/mrsid/Lidar_DSDK/lib/* /usr/local/lib
    fi

    if [ ! -d "#{src_path}/libkml" ]; then
      mkdir -p #{src_path}/libkml
      tar xzf #{sdk_kml} --strip 1 -C #{src_path}/libkml
      cp -r #{src_path}/libkml/include/* /usr/local/include
      cp -r #{src_path}/libkml/lib/* /usr/local/lib
    fi

    if [ ! -d "#{src_path}/libecwj2" ]; then
      mkdir -p #{src_path}/libecwj2
      tar xzf #{sdk_ecw} --strip 1 -C #{src_path}/libecwj2
      cp -r #{src_path}/libecwj2/include/* /usr/local/include
      cp -r #{src_path}/libecwj2/lib/* /usr/local/lib
    fi

    if [ ! -d "#{src_path}/openjpeg" ]; then
      mkdir -p #{src_path}/openjpeg
      tar xzf #{sdk_openjpeg} --strip 1 -C #{src_path}/openjpeg
      cp -r #{src_path}/openjpeg/include/* /usr/local/include
      cp -r #{src_path}/openjpeg/lib/* /usr/local/lib
    fi

    if [ ! -d "#{src_path}/mdb-sqlite" ]; then
      mkdir -p #{src_path}/mdb-sqlite
      tar xjvf #{sdk_mdb} --strip 1 -C #{src_path}/mdb-sqlite
      cp #{src_path}/mdb-sqlite/lib/*.jar /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/ext
    fi

    ldconfig
  EOS
  action :run
  user "root"
end

execute "Configure GDAL" do
  command <<-EOS
    cd /usr/local/src/gdal
    ./configure \
      --with-local \
      --prefix=/usr/local \
      --with-threads \
      --with-libtool \
      --with-bsb \
      --with-grib \
      --with-pam \
      --with-liblzma \
      --with-expat=/usr \
      --with-sqlite3=/usr \
      --with-python \
      --with-geos \
      --with-spatialite \
      --with-netcdf \
      --with-jpeg \
      --with-jpeg12 \
      --with-gif \
      --with-poppler \
      --with-webp \
      --with-java \
      --with-jvm-lib-add-rpath \
      --with-mdb \
      --with-libkml \
      --with-mrsid=/usr/local \
      --with-fgdb=/usr/local \
      --with-mrsid=/usr/local \
      --with-mrsid-lidar=/usr/local \
      --with-jp2mrsid \
      --with-openjpeg=/usr/local \
      --with-ecw=/usr/local
  EOS
  action :run
  user "root"
end

execute "Build and install GDAL" do
  command <<-EOS
    cd /usr/local/src/gdal
    make
    make install
    ldconfig
  EOS
  action :run
  user "root"
end
