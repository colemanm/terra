%w[wget curl zip ack python-software-properties autoconf bison flex libyaml-dev libtool make vim git subversion openjdk-7-jdk].each do |pkg|
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
# %w[
#   libsqlite3-dev
#   libproj-dev
#   libgeos-dev
#   libspatialite-dev
#   libgeotiff-dev
#   libgdal-dev
#   gdal-bin
#   openjdk-7-jdk
# ]
