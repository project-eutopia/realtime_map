# This class holds all the things needed in the map:  the map itself, data used
# for displaying on the map, and the loop that updates the map and the database
# check
class window.MapBox
  constructor: (initial_json) ->
    @markers = {}
    @map = null
    
    @fps = initial_json["fps"]
    @max_markers = initial_json["max_markers"]

    @loadMap()
    @client_side_start_time = Date.now()
    
    # This event called when a marker completely fades out, and needs to be removed
    # This deleting is called by the Marker when deactivate is called
    window.$map_div.on "remove_marker", (event, marker) =>
      delete @markers[marker.id]
      console.debug("Removed marker with key = " + marker.id)
      
    # Get various buttons
    $( ".remove-error-markers" ).on( "click", =>
      @remove_error_markers()
    )
    $( ".remove-all-markers" ).on( "click", =>
      @remove_all_markers()
    )
    
    @add_markers(initial_json["markers"])

    # This interval periodically will call the server for more data to display
    setInterval ( =>
      @get_recent_purchases()
    ), initial_json["seconds_between_calls"]*1000
    
  
  remove_error_markers: ->
    for key, marker of @markers
      if marker instanceof window.ErrorMarker
        marker.deactivate()
    
  remove_all_markers: ->
    for key, marker of @markers
      marker.deactivate()
  
  # Loads the Google map
  loadMap: ->

    mapOptions =
      zoom: 2
      center: new google.maps.LatLng(20, 8)
      mapTypeId: google.maps.MapTypeId.ROADMAP

    # Build the map
    @map = new google.maps.Map(document.getElementById(window.map_div_id), mapOptions)
   

  # Adds markers specified by the JSON into the @markers hash
  add_markers: (json) ->
    if @map != null
      for marker_json in json
        # Enclosure
        do (marker_json) =>
          setTimeout ( =>
            @add_marker(marker_json)
          ), (@client_side_start_time + marker_json.delay_ms) - Date.now()
  
  
  add_marker: (marker_json) ->
    if Object.keys(@markers).length < @max_markers
      @markers[marker_json.id] = Marker.factory(marker_json, @map, @fps)
      console.debug("Added new marker: " + @markers[marker_json.id])
    else
      console.warn("LIMIT!  Couldn't add new marker.  Current size = " + Object.keys(@markers).length)
    
  
  get_recent_purchases: ->

    $.ajax "/map/query.json",
      type: "GET"
      success: (data, status, xhr) =>
        console.debug("AJAX, received new JSON data")
        @add_markers(data["markers"])
      error: (xhr, status, error) =>
        console.error(xhr)
        alert(error)
      #data:
        #last_query: @last_query_time
