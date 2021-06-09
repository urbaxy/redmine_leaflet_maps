require 'redmine'
require 'rexml/document'

Redmine::Plugin.register :redmine_leaflet_maps do
  name 'Redmine Leaflet Maps plugin'
  author 'urbaxy'
  description 'macro to use leaflet maps'
  version '0.2'
  url 'https://github.com/urbaxy/redmine_leaflet_maps'
  author_url 'https://github.com/urbaxy'
  settings :default => {'leaflet_url_js' => 'https://unpkg.com/leaflet@1.7.1/dist/leaflet.js', 'leaflet_url_css' => 'https://unpkg.com/leaflet@1.7.1/dist/leaflet.css', 'leaflet_url_tile' => 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'}, :partial => 'settings/leaflet_maps_settings'

  Redmine::WikiFormatting::Macros.register do
    desc "Embeds a leaflet map\n\n  {{leaflet_map(longitude, latitude)}}\n  {{leaflet_map(longitude, latitude, zoom)}}"
    macro :leaflet_map do |obj, args|
      gpslon = 16
      gpslon = args[0].strip if args[0]
      gpslat = 48
      gpslat = args[1].strip if args[1]
      gpszoom = 14
      gpszoom = args[2].strip if args[2]
      o = '<link rel="stylesheet" href="' + Setting.plugin_redmine_leaflet_maps['leaflet_url_css'] + '" /><script src="' + Setting.plugin_redmine_leaflet_maps['leaflet_url_js'] + '"></script><div id="map" style="width: 100%; height: 400px;"></div><script type="text/javascript">var map = L.map (\'map\').setView ([' + gpslon + ', ' + gpslat + '], ' + gpszoom + '); L.tileLayer (\'' + Setting.plugin_redmine_leaflet_maps['leaflet_url_tile'] + '\').addTo (map);</script>'

      return o.html_safe
    end
  end

  Redmine::WikiFormatting::Macros.register do
    desc "Shows marker on a leaflet map\n\n  {{leaflet_marker(longitude, latitude)}}\n  {{leaflet_marker(longitude, latitude, tile}}"
    macro :leaflet_marker do |obj, args|
      gpslon = 16
      gpslon = args[0].strip if args[0]
      gpslat = 48
      gpslat = args[1].strip if args[1]
      title = ''
      title = args[2].strip if args[2]
      o = '<script>L.marker([' + gpslon + ', ' + gpslat + '], {title: \'' + title + '\'}).addTo(map);</script>'

      return o.html_safe
    end
  end

  Redmine::WikiFormatting::Macros.register do
    desc "Shows tracks and POIs from a gpx file on a leaflet map\n\n  {{leaflet_gpx(filename)}}"
    macro :leaflet_gpx do |obj, args|
      filename = args[0].strip if args[0]
      storage_path = Redmine::Configuration['attachments_storage_path'] || File.join(Rails.root, "files")
      attachment = Attachment.latest_attach(obj.attachments, filename)
      o = '<script>'
      xmlfile = File.new(storage_path + '/' + attachment.disk_directory + '/' + attachment.disk_filename)
      xmldoc = REXML::Document.new(xmlfile)
      #Waypoints
      xmldoc.elements.each('gpx/wpt') do |wpt|
        o = o + 'L.marker([' + wpt.attributes['lat'] + ', ' + wpt.attributes['lon'] + '], {title: \'' + wpt.elements['name'].text.gsub("\'", "´") + '\'}).addTo(map);'
      end
      #Tracks
      xmldoc.elements.each('gpx/trk') do |trk|
        o = o + 'var tpts = [];'
        trk.elements.each('trkseg/trkpt') do |tpt|
          o = o + 'tpts.push([' + tpt.attributes['lat'] + ', ' + tpt.attributes['lon'] + ']);'
        end
        o = o + 'L.marker(tpts[0], {title: \'' + trk.elements['name'].text.gsub("\'", "´") + '\'}).addTo(map); L.polyline(tpts, {color : \'#0000ff\'}).addTo(map);'
      end
      #Routes
      xmldoc.elements.each('gpx/rte') do |rte|
        o = o + 'var tpts = [];'
        rte.elements.each('rtept') do |tpt|
          o = o + 'tpts.push([' + tpt.attributes['lat'] + ', ' + tpt.attributes['lon'] + ']);'
        end
        o = o + 'L.marker(tpts[0], {title: \'' + rte.elements['name'].text.gsub("\'", "´") + '\'}).addTo(map); L.polyline(tpts, {color : \'blue\'}).addTo(map);'
      end
      o = o + '</script>'

      return o.html_safe
    end
  end
end
