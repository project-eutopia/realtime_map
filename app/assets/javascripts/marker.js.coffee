# This is the base class that all Markers will inherit from.
# The following are a list of all methods that should be overriden by subclasses
#
# setup_markers():
#   Called in the constructor. Create any google marker objects your Marker will
#   use here.
#
# cleanup():
#   Called from deactivate() when the Marker is to be removed.  Clean up any
#   markers that were created in setup_markers() here.
#
# resize():
#   This is called whenever the map is resized.  In here you should recalculate
#   bounds or sizes needed for markers when the map size changes.
#
# update_marker():
#   This is called every animation frame.  Use it to implement fadeouts, blinking,
#   and other changes.  The instance variables @create_time and @finish_time
#   are used to denote start and finish of the animation.
#
# get_finish_time():
#   This is called to determine the time the animation will finish.  It is called
#   after seting @create_time.  Can override to give custom @finish_time value
#   that is used in the method is_finished()
#
# is_finished():
#   Can set custom finish criteria here.  The animation loop created in
#   start_animation will call is_finished().  The default is_finished() code
#   calls deactivate() when the animation finishes, to start cleanup of the class



class window.Marker
  @initFillOpacity = 0.40
  @initStrokeOpacity = 0.85
  @lifetime_ms_default = 4500
  
  @factory: (json, map, fps) ->
    console.debug(json.marker_name)
    console.debug(window.marker_class_list)
    console.debug(window.marker_class_list[json.marker_name])
    return new window.marker_class_list[json.marker_name](json, map, fps)
  
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
    
    @setup_markers()
    @set_resize_listener()

    # Fadeout the marker
    @start_animation(fps)
    

  # abstract
  setup_markers: ->
    #
    
  # abstract
  cleanup: ->
    #

  set_resize_listener: ->
    @resize_listener = google.maps.event.addListener(@map, 'zoom_changed', =>
      @resize()
    )

  # override, and call super()
  resize: ->
    @update_marker()

  # abstract
  update_marker: ->
    #

  get_finish_time: ->
    return @create_time + Marker.lifetime_ms_default
    
    
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
      
      # Stop the fadeout loop
      if @start_animation_interval
        clearInterval(@start_animation_interval)
        
      @resize_listener.remove()
      
      # Tell the map that this marker is done, so the memory can be freed
      window.$map_div.trigger "remove_marker", this
  

    
  start_animation: (fps) ->
    @start_animation_interval = setInterval ( =>
      # If done animating, remove
      unless @is_finished()
        @update_marker()
        
    ), 1000 / fps
        
        

