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
    center = new google.maps.LatLng(@lat, @lng)
    proj = @map.getProjection()
    center_point = proj.fromLatLngToPoint(center)

    map_bounds = @map.getBounds()
    map_sw_point = proj.fromLatLngToPoint(map_bounds.getSouthWest())
    map_ne_point = proj.fromLatLngToPoint(map_bounds.getNorthEast())

    width  = map_ne_point.x - map_sw_point.x
    height = map_sw_point.y - map_ne_point.y
    long = if (width > height) then true else false
    scale = Math.min(width, height) / 30.0
    
    sw_point = new google.maps.Point(center_point.x - scale, center_point.y + scale)
    ne_point = new google.maps.Point(center_point.x + scale, center_point.y - scale)
    
    @rect_bounds = new google.maps.LatLngBounds(
      proj.fromPointToLatLng(sw_point),
      proj.fromPointToLatLng(ne_point)
    )

    return @rect_bounds
    
  
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

