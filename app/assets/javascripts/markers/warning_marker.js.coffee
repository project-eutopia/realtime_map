class window.WarningMarker extends window.Marker
  @lifetime_ms_default = 15000

  constructor: (json, map, fps) ->
    super(json, map, fps)

  # Override
  setup_markers: ->
    @get_bounds()
    @google_marker = new google.maps.Rectangle( @rectangle_options() )
      
  rectangle_options: ->
    cur_time = Date.now()

    map: @map
    strokeWeight: 2
    strokeColor: @color
    strokeOpacity: window.Marker.initStrokeOpacity * Math.max(@finish_time - cur_time, 0) / (@finish_time - @create_time)
    fillColor: @color
    fillOpacity: window.Marker.initFillOpacity * Math.max((@finish_time-@create_time) - 1.4*(cur_time-@create_time), 0) / (@finish_time - @create_time)
    bounds: @rect_bounds
    
  # Need to recalculate the rectangle bounds after resize
  resize: ->
    @get_bounds()
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
    
    sw_point = new google.maps.Point(center_point.x - scale, center_point.y + scale)
    ne_point = new google.maps.Point(center_point.x + scale, center_point.y - scale)
    
    @rect_bounds = new google.maps.LatLngBounds(
      proj.fromPointToLatLng(sw_point),
      proj.fromPointToLatLng(ne_point)
    )
    
  # Override
  cleanup: ->
    # Remove the resize_listener
    @resize_listener.remove()
    
    # The rest of the cleanup is handled by the superclass
    super()

  # Override
  get_finish_time: ->
    @create_time + WarningMarker.lifetime_ms_default
    
  # Override
  update_marker: ->
    if @google_marker
      @google_marker.setOptions( @rectangle_options() )

