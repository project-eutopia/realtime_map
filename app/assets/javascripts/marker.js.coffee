class window.Marker
  @initFillOpacity = 0.40
  @initStrokeOpacity = 0.85
  @lifetime_ms_default = 4500
  
  constructor: (create_time, lat, lng, radius, color, map) ->
    @create_time = create_time
    @finish_time = @create_time + Marker.lifetime_ms_default
    
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
    # Initially the marker is invisible, until we reach the create_time
    @google_marker.setVisible(false)
  
  is_finished: ->
    if Date.now() > @finish_time
      @deactivate()
      return true
    else
      return false
    
  deactivate: ->
    @active = false
    @google_marker.setMap(null)
  
  # Returns true if finished, false if not
  update: ->
    if @active == false
      return true
    
    ms_passed = Date.now() - @create_time
     
    # If done animating, remove
    if ms_passed > Marker.lifetime_ms_default
      @deactivate()
      return true
    # If ms_passed is negative, the marker is not yet to be displayed
    else if ms_passed >= 0
      @google_marker.setVisible(true)
      # Note, it looks nicer when the lighter fill color completely fades out first,
      # before the circle outline does
      @google_marker.setIcon(
        path: google.maps.SymbolPath.CIRCLE
        strokeWeight: 2
        strokeColor: @color
        strokeOpacity: Marker.initStrokeOpacity * (Marker.lifetime_ms_default - ms_passed) / Marker.lifetime_ms_default
        fillColor: @color
        fillOpacity: Marker.initFillOpacity * Math.max(Marker.lifetime_ms_default - 1.4*ms_passed, 0) / Marker.lifetime_ms_default
        scale: @radius
      )
      
    return false
      
