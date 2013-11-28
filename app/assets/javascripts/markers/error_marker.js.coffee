class window.ErrorMarker extends window.Marker

  # Override
  get_google_marker: ->
    @get_bounds()
    
    @google_marker = new google.maps.Polygon(
      map: @map
      paths: @diamond_coords
      strokeWeight: 2
      strokeColor: "#FF0000"
      strokeOpacity: window.Marker.initStrokeOpacity
      fillColor: @color
      fillOpacity: window.Marker.initFillOpacity
    )
    @center_circle = new google.maps.Marker(
      position: new google.maps.LatLng(@lat, @lng)
      map: @map
      icon:
        path: google.maps.SymbolPath.CIRCLE
        strokeWeight: 4
        strokeColor: "#FF0000"
        strokeOpacity: Marker.initStrokeOpacity
        scale: 2
    )
    
    ## ADD LISTENER FOR INFOWINDOW
    infowindow = new google.maps.InfoWindow(
      content: "<p>hellooooooooooo world " + @id + "</p>"
      disableAutoPan: true
    )
    google.maps.event.addListener(@google_marker, 'click', =>
      infowindow.open(@map, @center_circle)
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
    
    latlng_right = proj.fromPointToLatLng(new google.maps.Point(center_point.x + scale, center_point.y))
    latlng_up    = proj.fromPointToLatLng(new google.maps.Point(center_point.x, center_point.y - scale))
    latlng_left  = proj.fromPointToLatLng(new google.maps.Point(center_point.x - scale, center_point.y))
    latlng_down  = proj.fromPointToLatLng(new google.maps.Point(center_point.x, center_point.y + scale))
    
    @diamond_coords = [
      latlng_right,
      latlng_up,
      latlng_left,
      latlng_down,
      latlng_right
    ]
    
  
  # Override
  get_finish_time: ->
    Infinity
    
  is_finished: ->
    false
    
  # Override
  update_marker: ->
    if @center_circle.getVisible()
      @center_circle.setVisible(false)
    else
      @center_circle.setVisible(true)
