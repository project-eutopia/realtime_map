#= require marker

class window.ErrorMarker extends window.Marker

  # Override
  setup_markers: ->
    @get_bounds()
    
    @google_marker = new google.maps.Polygon( @polygon_options() )
    @center_circle = new google.maps.Marker(
      position: new google.maps.LatLng(@lat, @lng)
      map: @map
      icon: @circle_icon()
    )
    
    # Create info window for display once clicked
    @info_string = $( '<div class="error-marker-info">'+
                      '<p>Error with marker!</p>'+
                      '<p>Id = ' + @id + '</p>'+
                      '<br>'+
                      '<button class=\"error-info-button\" id=\"error-info-button-'+@id+'\" title=\"Remove Marker\">'+
                        'Remove Marker'+
                      '</button>'+
                      '</div>' )
    @infowindow = new google.maps.InfoWindow(
      content: @info_string[0]
      disableAutoPan: true
    )
    
    # Open info window when clicked
    @marker_click_listener = google.maps.event.addListener(@google_marker, 'click', =>
      @infowindow.open(@map, @center_circle)
    )
    
    # Add listener for the remove marker button
    removeBtn = @info_string.find("#error-info-button-"+@id+"")[0]
    @info_button_listener = google.maps.event.addDomListener removeBtn, "click", (event) =>
      event.preventDefault()
      @deactivate()
      
      
  resize: ->
    @get_bounds()
    @google_marker.setOptions( @polygon_options() )
  
  polygon_options: ->
    map: @map
    paths: @diamond_coords
    strokeWeight: 2
    strokeColor: "#FF0000"
    strokeOpacity: window.Marker.initStrokeOpacity
    fillColor: @color
    fillOpacity: window.Marker.initFillOpacity
    
  circle_icon: ->
    path: google.maps.SymbolPath.CIRCLE
    strokeWeight: 4
    strokeColor: "#FF0000"
    strokeOpacity: Marker.initStrokeOpacity
    scale: 2


  cleanup: ->
    # Close down the parts of this marker unique to it
    @google_marker.setMap(null)
    @center_circle.setMap(null)
    @infowindow.close()
    google.maps.event.removeListener(@info_button_listener)
    google.maps.event.removeListener(@marker_click_listener)
    super()
    
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
  
  # Override
  is_finished: ->
    false
  
  # Override (ignore the FPS, and have a slowish blink)
  start_animation: (fps) ->
    @start_animation_interval = setInterval ( =>
      # If done animating, remove
      unless @is_finished()
        @update_marker()
        
    ), 200
    
  # Override
  update_marker: ->
    if @center_circle
      if @center_circle.getVisible()
        @center_circle.setVisible(false)
      else
        @center_circle.setVisible(true)
