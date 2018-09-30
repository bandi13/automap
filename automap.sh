#!/bin/bash

########### CONFIGURATION ##############
#### MAP
# Specify map and continent name and paths
# from download.geofabrik.de
#
# e.g:
#
# MAP="great-britain"
# CONTINENT="europe"
#
# or:
#
# MAP="wales"
# CONTINENT="europe/great-britain"
#
# or:
#
# MAP="europe"
# CONTINENT=""

MAP="wales"
CONTINENT="europe/great-britain"

############## END OF CONFIGURATION ###################
JAVAMEMSIZE=$(free -m | awk '/^Mem:/{print " -Xmx"$2"M"}')

POLYURL="http://download.geofabrik.de/$CONTINENT/$MAP.poly"
PBFMAPURL="http://download.geofabrik.de/$CONTINENT/$MAP-latest.osm.pbf"
CITIES="cities15000.zip"
CITIESURL="http://download.geonames.org/export/dump/"$CITIES

echo "----> Downloading map"
wget -q $PBFMAPURL &
wget -q $POLYURL &
wget -q $CITIESURL &
wait

echo "----> Converting to o5m"
./osmconvert --verbose $MAP-latest.osm.pbf --out-o5m > $MAP.o5m.base && ./osmupdate -v $MAP.o5m.base $MAP.o5m -B=$MAP.poly

echo "-----> Splitting map"
java $JAVAMEMSIZE -jar ./splitter/dist/splitter.jar --geonames-file=$CITIES --output=o5m $MAP.o5m

echo "-----> Extracting boundaries"
./osmfilter --verbose $MAP.o5m --keep-nodes= --keep-ways-relations="boundary=administrative =postal_code postal_code=" --out-o5m > $MAP-boundaries.o5m

echo "-----> Preprocessing boundaries"
java $JAVAMEMSIZE -cp ./mkgmap/dist/mkgmap.jar uk.me.parabola.mkgmap.reader.osm.boundary.BoundaryPreprocessor $MAP-boundaries.o5m bounds

#### Create IMG file
# This is the mkgmap command used to generate the gmapsupp.img Garmin map file.
# Modify options and use your custom styles here.
# Options are described at http://wiki.openstreetmap.org/wiki/Mkgmap/help/options

echo "-----> Creating gmapsupp.img file"
java $JAVAMEMSIZE -jar ./mkgmap/dist/mkgmap.jar --route --latin1 --bounds=bounds --location-autofill=bounds,is_in,nearest --adjust-turn-headings --link-pois-to-ways --ignore-turn-restrictions --check-roundabouts --add-pois-to-areas --preserve-element-order --add-pois-to-lines --index --gmapsupp -c template.args

mv gmapsupp.img output/.
