class window.Marker
  @initFillOpacity = 0.40
  @initStrokeOpacity = 0.85
  @lifetime_ms_default = 4500
  
  constructor: (json, map, fps) ->
    @id = json.id
    @create_time = Date.now()
    @finish_time = @create_time + Marker.lifetime_ms_default
    
    @active = true
    @radius = json.radius
    @color = json.color
    @fradulent_score = json.fradulent_score
    
    @google_marker = new google.maps.Marker(
      position: new google.maps.LatLng(json.lat, json.lng)
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

    # Fadeout the marker
    @fadeOutInterval = null
    @start_animation(fps)
  
  is_finished: ->
    if @active == false
      return true
    else if Date.now() > @finish_time
      @deactivate()
      return true
    else
      return false
    
  deactivate: ->
    @active = false
    @google_marker.setMap(null)
    
    # Stop the fadeout loop
    unless @start_animation_interval is null
      clearInterval(@start_animation_interval)
      
    # Tell the map that this marker is done, so the memory can be freed
    window.$map_div.trigger "remove_marker", this
    
  start_animation: (fps) ->
    @start_animation_interval = setInterval ( =>
      cur_time = Date.now()
      
      # If done animating, remove
      if cur_time > @finish_time
        @deactivate()
      else
        @update_marker(cur_time)
        
    ), 1000 / fps
        
  update_marker: (cur_time) ->
    # Note, it looks nicer when the lighter fill color completely fades out first,
    # before the circle outline does
    @google_marker.setIcon(
      path: google.maps.SymbolPath.CIRCLE
      strokeWeight: 2
      strokeColor: @color
      strokeOpacity: Marker.initStrokeOpacity * (@finish_time - cur_time) / (@finish_time - @create_time)
      fillColor: @color
      fillOpacity: Marker.initFillOpacity * Math.max((@finish_time-@create_time) - 1.4*(cur_time-@create_time), 0) / (@finish_time - @create_time)
      scale: @radius
    )

