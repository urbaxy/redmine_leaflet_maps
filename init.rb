require 'redmine'

Redmine::Plugin.register :redmine_leaflet_maps do
  name 'Redmine Leaflet Maps plugin'
  author 'urbaxy'
  description 'macro to use leaflet maps'
  version '0.1'
  url 'https://github.com/urbaxy/redmine_leaflet_maps'
  author_url 'https://github.com/urbaxy'
  settings :default => {'leaflet_url_js' => 'https://unpkg.com/leaflet@1.6.0/dist/leaflet.js', 'leaflet_url_css' => 'https://unpkg.com/leaflet@1.6.0/dist/leaflet.css', 'leaflet_url_tile' => 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'}, :partial => 'settings/leaflet_maps_settings'

  Redmine::WikiFormatting::Macros.register do
    desc "Embeds leaflet map\n\n  {{leaflet_map(longitude, latitude)}}\n  {{leaflet_map(longitude, latitude, zoom)}}"
    macro :leaflet_map do |obj, args|
      gpslon = 16
      gpslon = args[0].strip if args[0]
      gpslat = 48
      gpslat = args[1].strip if args[1]
      gpszoom = 14
      gpszoom = args[2].strip if args[2]
      o = '<link rel="stylesheet" href="' + Setting.plugin_redmine_leaflet_maps['leaflet_url_css'] + '" /><script src="' + Setting.plugin_redmine_leaflet_maps['leaflet_url_js'] + '"></script><div id="map" style="width: 600px; height: 400px;"></div><script type="text/javascript">var map = L.map (\'map\').setView ([' + gpslon + ', ' + gpslat + '], ' + gpszoom + '); L.tileLayer (\'' + Setting.plugin_redmine_leaflet_maps['leaflet_url_tile'] + '\').addTo (map);</script>'

      return o.html_safe
    end
  end

  Redmine::WikiFormatting::Macros.register do
    desc "Shows marker on leaflet map\n\n  {{leaflet_marker(longitude, latitude)}}\n  {{leaflet_marker(longitude, latitude, tile}}"
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
end
