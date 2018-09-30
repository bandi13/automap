This is a Docker container that has all the tools necessary for creating gmapsupp.img files on any map from OpenStreetMap. To run the container, simply do:
docker run bandi13/gmapsupp-generator -it --rm -v ~/:/root/output

Then you can run 'cd /root && automap.sh' to generate the default map, or edit the variables in automap.sh to your liking. The temporary files will be kept in the container, and the gmapsupp.img will be copied to '/root/output' which is a volume that's mapped to '~/' on the host.

automap
=======

Script that automatically creates an up-to-date routable OpenStreetMap for a specified region in Garmin img format:

- downloads map generation tools (mkgmap, splitter, osm*) from their respective sites
- downloads a map from geofabrik.de: downloads the full specified map and updates it to latest OSM timestamp
- handles pbf to o5m conversion
- splits maps using GeoName cities list
- extracts and preprocesses boundaries (administrative and postal codes)
- creates a routable map in Garmin format (gmapsupp.img) using your options and style

Note: This script can run for a long time depending on the size of the area you select.
