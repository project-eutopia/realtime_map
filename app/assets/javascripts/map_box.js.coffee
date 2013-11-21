# This class holds all the things needed in the map:  the map itself, data used
# for displaying on the map, and the loop that updates the map and the database
# check
class window.MapBox
  constructor: (div_id, initial_json) ->
    @markers = {}
    @map = null
    
    @loadMap(div_id)
    @client_side_start_time = Date.now()
    @add_markers(initial_json["markers"])
    
    callback = @get_recent_purchases.bind(@)
    setInterval ( ->
      callback.call()
    ), initial_json["seconds_between_calls"]*1000
    
    @drawing_loop(initial_json["fps"])
  
  # Loads the Google map
  loadMap: (div_id) ->

    mapOptions =
      zoom: 2
      center: new google.maps.LatLng(20, 8)
      mapTypeId: google.maps.MapTypeId.ROADMAP

    # Build the map
    @map = new google.maps.Map(document.getElementById(div_id), mapOptions)
    

  # Adds markers specified by the JSON into the @markers hash
  add_markers: (json) ->
    if @map != null
      for marker_json in json
        @markers[marker_json.id] = new Marker(@client_side_start_time + marker_json.delay_ms, marker_json.lat, marker_json.lng, marker_json.radius, marker_json.color, @map)
    console.log("Added new markers")
    console.log(@markers)
  
  
  # This is the drawing loop that calls update on all the markers
  drawing_loop: (fps) ->
    @update_markers()
    
    callback = @drawing_loop.bind(@, fps)
    setTimeout ( ->
      callback.call()
    ), 1000 / fps
    
    
  # Loops through all active markers and updates each's animation,
  # cleaning up finished markers at the end
  update_markers: ->
    # Record any markers that have finished animating for removal
    finished_markers_keys = []
    
    for key, marker of @markers
      if marker.update() == true
        finished_markers_keys.push(key)
    
    # Remove markers that have finished after the update loop
    for key in finished_markers_keys
      delete @markers[key]
      console.log("Removed marker with key = " + key)
      

  get_recent_purchases: ->

    $.ajax "/map/query",
      type: "GET"
      success: (data, status, xhr) =>
        console.log("AJAX, received new JSON data")
        @add_markers(data["markers"])
      error: (xhr, status, error) =>
        console.log(xhr)
        alert(error)
      #data:
        #last_query: @last_query_time
