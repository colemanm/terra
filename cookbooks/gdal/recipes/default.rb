
execute "Download GDAL" do
  command <<-EOS
    cd /usr/local/src &&
    wget http://download.osgeo.org/gdal/1.10.0/gdal-1.10.0.tar.gz &&
    tar xvzf gdal-1.10.0.tar.gz
  EOS
  action :run
  user "root"
end

execute "Download and copy external libraries" do
  command <<-EOS
    cd /usr/local/src &&
    wget https://terra-libs.s3.amazonaws.com/FileGDB_API_1_2-64.tar.gz &&
    wget https://terra-libs.s3.amazonaws.com/MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44.tar.gz
    wget https://terra-libs.s3.amazonaws.com/install-libecwj2-ubuntu12.04-64bit.tar.gz &&
    wget https://terra-libs.s3.amazonaws.com/install-openjpeg-2.0.0-ubuntu12.04-64bit.tar.gz &&

    tar xzf FileGDB_API_1_2-64.tar.gz
    cp -r FileGDB_API/include/* /usr/local/include
    cp -r FileGDB_API/lib/* /usr/local/lib
    tar xzf MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44.tar.gz
    cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Raster_DSDK/include/* /usr/local/include
    cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Raster_DSDK/lib/* /usr/local/lib
    cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Lidar_DSDK/include/* /usr/local/include
    cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Lidar_DSDK/lib/* /usr/local/lib
    tar xzf install-libecwj2-ubuntu12.04-64bit.tar.gz
    cp -r install-libecwj2/include/* /usr/local/include
    cp -r install-libecwj2/lib/* /usr/local/lib
    tar xzf install-openjpeg-2.0.0-ubuntu12.04-64bit.tar.gz
    cp -r install-openjpeg/include/* /usr/local/include
    cp -r install-openjpeg/lib/* /usr/local/lib
  EOS
  action :run
  user "root"
end

execute "Configure GDAL" do
  command <<-EOS

  EOS
  action :run
  user "root"
end