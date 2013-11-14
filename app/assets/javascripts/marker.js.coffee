class @Marker
  @initFillOpacity = 0.40
  @initStrokeOpacity = 0.85
  @lifetime_ms_default = 4500
  
  constructor: (lat, lng, radius, color, map) ->
    @create_time = Date.now()
    @finish_time = @create_time + @lifetime_ms_default
    
    @active = true
    @radius = radius
    @color = color
    
    @google_marker = new google.maps.Marker(
      position: new google.maps.LatLng(lat, lng)
      map: map
      icon:
        path: google.maps.SymbolPath.CIRCLE
        strokeWeight: 2
        strokeColor: @color
        strokeOpacity: Marker.initStrokeOpacity
        fillColor: @color
        fillOpacity: Marker.initFillOpacity
        scale: @radius
    )
  
  is_finished: ->
    if Date.now() > @finish_time
      @active = false
      return true
    else
      return false
  
  # Returns true if finished, false if not
  update: ->
    ms_passed = Date.now() - @create_time
      
    if @active == true or ms_passed > @lifetime_ms_default
      @active = false
      return true
    else
      # Note, it looks nicer when the lighter fill color completely fades out first,
      # before the circle outline does
      @googleMarker.setIcon(
        path: google.maps.SymbolPath.CIRCLE
        strokeWeight: 2
        strokeColor: @color
        strokeOpacity: Marker.initStrokeOpacity * (@lifetime_ms_default - ms_passed) / @lifetime_ms_default
        fillColor: @color
        fillOpacity: Marker.initFillOpacity * Math.max(@lifetime_ms_default - 1.4*ms_passed, 0) / @lifetime_ms_default
        scale: @radius
      )
      
      return false
      