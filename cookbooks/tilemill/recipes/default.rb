["add-apt-repository ppa:developmentseed/mapbox -y", "apt-get update"].each do |cmd|
  execute cmd do
    user "root"
  end
end

%w[
  tilemill
  nodejs
].each do |pkg|
  package pkg do
    action :install
  end
end
