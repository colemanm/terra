# Extract MrSID SDK
sudo mkdir -p /usr/local/src/mrsid
sudo tar xvzf ~/src/MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44.tar.gz --strip 1 -C /usr/local/src/mrsid

# Build GDAL
wget http://download.osgeo.org/gdal/1.10.0/gdal-1.10.0.tar.gz
tar xvzf gdal-1.10.0.tar.gz
cd gdal-1.10.0
./configure --with-filegdb=/usr/local/src/filegdb
make
sudo make install
sudo ldconfig

# Manually move some shared libs
sudo cp /usr/local/src/mrsid/Raster_DSDK/lib/libltidsdk.so /usr/local/lib
sudo cp /usr/local/src/mrsid/Lidar_DSDK/lib/liblti_lidar_dsdk.so /usr/local/lib
sudo ldconfig

# Test

wget ftp://146.201.97.137/DOQQ/2004/RGB/UTM/MrSid/g31-sids/Q3122ne.sid
gdalinfo -stats Q3122ne.sid