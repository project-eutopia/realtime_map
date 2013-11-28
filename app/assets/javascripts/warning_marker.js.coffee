class window.WarningMarker extends window.Marker
  @lifetime_ms_default = 15000

  # Override
  get_google_marker: ->
    return new google.maps.Rectangle(
      map: @map
      strokeWeight: 2
      strokeColor: @color
      strokeOpacity: window.Marker.initStrokeOpacity
      fillColor: @color
      fillOpacity: window.Marker.initFillOpacity
      bounds: @get_bounds()
    )
      
  get_bounds: ->
    whole_bounds = @map.getBounds()
    whole_bounds_ne = whole_bounds.getNorthEast()
    whole_bounds_sw = whole_bounds.getSouthWest()
    
    lat_size = (whole_bounds_ne.lat() - whole_bounds_sw.lat()) / 20.0
    lng_size = (whole_bounds_ne.lng() - whole_bounds_sw.lng()) / 40.0
    
    @rect_bounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(@lat - lat_size, @lng - lng_size),
      new google.maps.LatLng(@lat + lat_size, @lng + lng_size)
    )
  
  # Override
  get_finish_time: ->
    @create_time + WarningMarker.lifetime_ms_default
    
  # Override
  update_marker: ->
    cur_time = Date.now()
    
    # Note, it looks nicer when the lighter fill color completely fades out first,
    # before the circle outline does
    @google_marker.setOptions(
      map: @map
      strokeWeight: 2
      strokeColor: @color
      strokeOpacity: window.Marker.initStrokeOpacity * Math.max(@finish_time - cur_time, 0) / (@finish_time - @create_time)
      fillColor: @color
      fillOpacity: window.Marker.initFillOpacity * Math.max((@finish_time-@create_time) - 1.4*(cur_time-@create_time), 0) / (@finish_time - @create_time)
      bounds: @rect_bounds
    )

