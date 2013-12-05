class window.Marker
  @initFillOpacity = 0.40
  @initStrokeOpacity = 0.85
  @lifetime_ms_default = 4500
  
  @factory: (json, map, fps) ->
    if json.fradulent_score < 30
      return new window.WarningMarker(json, map, fps)
    else if json.fradulent_score > 80
      return new window.ErrorMarker(json, map, fps)
    else
      return new window.Marker(json, map, fps)
  
  constructor: (json, map, fps) ->
    @id = json.id
    @lat = parseFloat(json.lat)
    @lng = parseFloat(json.lng)
    @map = map
    
    @create_time = Date.now()
    @finish_time = @get_finish_time()
    
    @active = true
    @radius = json.radius
    @color = json.color
    @fradulent_score = json.fradulent_score
    
    @get_google_marker()

    # Fadeout the marker
    @fadeOutInterval = null
    @start_animation(fps)
    
  
  get_finish_time: ->
    return @create_time + Marker.lifetime_ms_default
    
    
  get_google_marker: ->
    @google_marker = new google.maps.Marker(
      position: new google.maps.LatLng(@lat, @lng)
      map: @map
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
    if @active == false
      return true
    else if Date.now() > @finish_time
      @deactivate()
      return true
    else
      return false
    
    
  deactivate: ->
    if @active
      @active = false
      
      @cleanup()
      
      # Tell the map that this marker is done, so the memory can be freed
      window.$map_div.trigger "remove_marker", this
  
  cleanup: ->
    @google_marker.setMap(null)
    # Stop the fadeout loop
    unless @start_animation_interval is null
      clearInterval(@start_animation_interval)

    
  start_animation: (fps) ->
    @start_animation_interval = setInterval ( =>
      # If done animating, remove
      unless @is_finished()
        @update_marker()
        
    ), 1000 / fps
        
        
  update_marker: ->
    cur_time = Date.now()
    
    # Note, it looks nicer when the lighter fill color completely fades out first,
    # before the circle outline does
    @google_marker.setIcon(
      path: google.maps.SymbolPath.CIRCLE
      strokeWeight: 2
      strokeColor: @color
      strokeOpacity: Marker.initStrokeOpacity * Math.max(@finish_time - cur_time, 0) / (@finish_time - @create_time)
      fillColor: @color
      fillOpacity: Marker.initFillOpacity * Math.max((@finish_time-@create_time) - 1.4*(cur_time-@create_time), 0) / (@finish_time - @create_time)
      scale: @radius
    )

