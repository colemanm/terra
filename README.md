# Terra

_Virtual environment for FOSS geo tools._

Terra lets you quickly get up and running with a server loaded with tons of useful open source geospatial tools - to get all the complexity of installation and configuration out of the way. Particularly useful for users wanting cool geo tools, but wanting to avoid dependency hell.

## Software

The box includes the following software tools ready to go:

* Ubuntu 12.04 Precise (x64)
* [GDAL](http://www.gdal.org/)
* [GEOS](http://trac.osgeo.org/geos/)
* [Proj](http://trac.osgeo.org/proj/)
* [SpatiaLite](http://www.gaia-gis.it/gaia-sins/)
* [Mapnik](http://mapnik.org/)
* PostgreSQL / PostGIS
* Ruby
* Python
* [TileMill](http://mapbox.com/tilemill)

## Requirements

Terra uses [Vagrant](http://vagrantup.com/) to quickly provision a local virtual machine, and [Chef](http://www.opscode.com/chef/) automation tools to get you up and running with a full suite in minutes.

First you need to install [VirtualBox](https://www.virtualbox.org/wiki/Downloads), then download and install [Vagrant](http://downloads.vagrantup.com/) for your platform. You'll also need to download the initial base box from the Vagrant catalog.

```shell
git clone https://github.com/colemanm/terra
cd terra
vagrant box add precise http://files.vagrantup.com/precise64.box

# Also need to have Berkshelf installed
vagrant plugin install vagrant-berkshelf
gem install berkshelf
berks install
```

## Usage

To start the VM provision process, run this single command from within the repository directory (the first build will take a bit since it's building several libraries from source):

    vagrant up

After several minutes, you'll have a virtual machine silently running that you can access. Get to the command line of your new geo environment:

    vagrant ssh

You can also suspend (save state and exit) or halt (shutdown) the machine like so:

    vagrant suspend
    vagrant halt

To completely delete and remove the virtual machine, destroy it:

    vagrant destroy

And completely rebuild again from scratch:

    vagrant up

## Working with Data

Once you've SSH'ed into your VM instance, you'll see a `data` directory if you list files. This folder is shared between the host (your computer) and the guest (the VM). Putting files you want to work with - like databases, shapefiles, or imagery - here will allow you to work with them in the VM sandbox for conversion, processing, and other tasks. This keeps it easy to have your geo toolbox clean and consistent for working with various data types.

If you put files in the '/data' dir in the terra local repo, they should show up in ~/data when you `ssh` to the VM. It should link to the directory on your machine, using VirtualBox shared folders.

## Testing it Out

On your VM, GDAL (the god of open geo data toolkits) will have full support for external libraries like FileGDB, Personal Geodatabases, ECW, and MrSID files. There's an included `Makefile` to download some sample data to try out:

    make data

This will save some samples in the `data/` directory that's visible within the VM's home. Try it out and see that tools like `ogrinfo` can read from a personal geodatabase:

```shell
vagrant ssh
cd data/
ogrinfo -so sample.mdb
```

Should get something like:

```shell
INFO: Open of `sample.mdb'
      using driver `MDB' successful.

Layer name: provinces
Geometry: Polygon
Feature Count: 183
Extent: (-180.000000, -90.000000) - (180.000000, 83.645130)
Layer SRS WKT:
GEOGCS["GCS_WGS_1984",
    DATUM["WGS_1984",
        SPHEROID["WGS_84",6378137.0,298.257223563]],
    PRIMEM["Greenwich",0.0],
    UNIT["Degree",0.0174532925199433]]
FID Column = OBJECTID
Geometry Column = Shape
OBJECTID: Integer (0.0)
scalerank: Integer (0.0)
featurecla: String (0.0)
....
```

## Changing Configuration

The `Vagrantfile` contains the basic configuration of the VM instance, like memory allocation and shared folders. From within this file is where it calls out to Chef to process the runlist living in `terra.json`. The runlist contains the manifest for which Chef "cookbooks" to run for autoinstallation and configuration of packages.
