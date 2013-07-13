
tar xvzf ~/src/FileGDB_API_1_2-64.tar.gz --strip 1 -C /usr/local/src/filegdb
cd /usr/local/src/filegdb/lib
ln -sf libfgdbunixrtl.so libfgdblinuxrtl.so
sudo sh -c 'echo "/usr/local/src/filegdb/lib" >> /etc/ld.so.conf'
sudo ldconfig
rm ~/src/FileGDB_API_1_2-64.tar.gz

wget http://download.osgeo.org/gdal/1.10.0/gdal-1.10.0.tar.gz
tar xvzf gdal-1.10.0.tar.gz
cd gdal-1.10.0
./configure --with-filegdb=/usr/local/src/filegdb
make
sudo make install
sudo ldconfig

# Test
ogrinfo --version

sudo echo /usr/local/lib > /etc/ld.so.conf.d/local.conf