# Redmine Leaflet Maps

A macro which displays a Leaflet map with Openstreetmap tiles. Custom tileservers are supported.

## Usage

{{leaflet_map(longitude, latitude, zoom)}}  
Shows a map with given center and zoom. Zoom is optional, default is 14.


{{leaflet_marker(longitude, latitude, title)}}  
Shows a marker on the map, title is optional. May be used multiple times.

{{leaflet_gpx(attachmentname)}}
Shows tracks, routes and waypoints from an attached gpx file on the map. May be used multiple times.

## Redmine version support

Tested only on Redmine version 3.4.

## Installation

cd /usr/share/redmine  
git clone https://github.com/urbaxy/redmine_leaflet_maps.git plugins/redmine_leaflet_maps  
bundle install  
apache2ctl graceful  

## Upgrade

cd /usr/share/redmine/plugins/redmine_leaflet_maps  
git pull  
bundle install  
apache2ctl graceful  

## Uninstallation

cd /usr/share/redmine/plugins  
rm -fr redmine_leaflet_maps  
apache2ctl graceful  

## Authors

- urbaxy

## Licence

GNU GPLv3
