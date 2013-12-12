#= require marker

class window.BasicMarker extends window.Marker

  # Override
  setup_markers: ->
    @google_marker = new google.maps.Marker(
      position: new google.maps.LatLng(@lat, @lng)
      map: @map
      icon: @marker_icon()
    )

  marker_icon: ->
    # Note, it looks nicer when the lighter fill color completely fades out first,
    # before the circle outline does
    cur_time = Date.now()
    
    path: google.maps.SymbolPath.CIRCLE
    strokeWeight: 2
    strokeColor: @color
    strokeOpacity: Marker.initStrokeOpacity * Math.max(@finish_time - cur_time, 0) / (@finish_time - @create_time)
    fillColor: @color
    fillOpacity: Marker.initFillOpacity * Math.max((@finish_time-@create_time) - 1.4*(cur_time-@create_time), 0) / (@finish_time - @create_time)
    scale: @radius
      
  resize: ->
    super()
            
  # Override
  cleanup: ->
    @google_marker.setMap(null)
    super()

  # Override
  update_marker: ->
    if @google_marker
      @google_marker.setIcon( @marker_icon() )

