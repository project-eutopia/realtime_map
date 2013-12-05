class window.WarningMarker extends window.Marker
  @lifetime_ms_default = 15000

  constructor: (json, map, fps) ->
    super(json, map, fps)

  # Override
  setup_markers: ->
    @get_bounds()
    @google_marker = new google.maps.Polygon( @polygon_options() )
      
  polygon_options: ->
    cur_time = Date.now()

    map: @map
    paths: @rect_coords
    strokeWeight: 2
    strokeColor: @color
    strokeOpacity: window.Marker.initStrokeOpacity * Math.max(@finish_time - cur_time, 0) / (@finish_time - @create_time)
    fillColor: @color
    fillOpacity: window.Marker.initFillOpacity * Math.max((@finish_time-@create_time) - 1.4*(cur_time-@create_time), 0) / (@finish_time - @create_time)

    
  # Need to recalculate the rectangle bounds after resize
  resize: ->
    @get_bounds()
    @update_marker()
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
    
    latlng_ur = proj.fromPointToLatLng(new google.maps.Point(center_point.x + scale, center_point.y - scale))
    latlng_ul = proj.fromPointToLatLng(new google.maps.Point(center_point.x - scale, center_point.y - scale))
    latlng_dl = proj.fromPointToLatLng(new google.maps.Point(center_point.x - scale, center_point.y + scale))
    latlng_dr = proj.fromPointToLatLng(new google.maps.Point(center_point.x + scale, center_point.y + scale))
    
    @rect_coords = [
      latlng_ur,
      latlng_ul,
      latlng_dl,
      latlng_dr,
      latlng_ur
    ]
    
  # Override
  cleanup: ->
    @google_marker.setMap(null)
    # Remove the resize_listener
    @resize_listener.remove()
    super()

  # Override
  get_finish_time: ->
    @create_time + WarningMarker.lifetime_ms_default
    
  # Override
  update_marker: ->
    if @google_marker
      @google_marker.setOptions( @polygon_options() )

