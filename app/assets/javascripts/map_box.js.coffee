# This class holds all the things needed in the map:  the map itself, data used
# for displaying on the map, and the loop that updates the map and the database
# check
class window.MapBox
  constructor: (div_id, initial_json) ->
    @markers = {}
    @map = null
    
    @fps = initial_json["fps"]

    @loadMap(div_id)
    @client_side_start_time = Date.now()
    @add_markers(initial_json["markers"])

    setInterval ( =>
      @get_recent_purchases()
      @clear_old_markers()
    ), initial_json["seconds_between_calls"]*1000
    
  
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
      for marker in json
        do (marker) =>
          setTimeout ( =>
            @markers[marker.id] = new Marker(marker.lat, marker.lng, marker.radius, marker.color, @map, @fps)
            console.log("Added new marker: " + @markers[marker.id])
          ), (@client_side_start_time + marker.delay_ms) - Date.now()
  
  
  # Loops through all active markers and updates each's animation,
  # cleaning up finished markers at the end
  clear_old_markers: ->
    # Record any markers that have finished animating for removal
    finished_markers_keys = []
    
    for key, marker of @markers
      if marker.is_finished()
        finished_markers_keys.push(key)
    
    # Remove markers that have finished after the update loop
    for key in finished_markers_keys
      delete @markers[key]
      console.log("Removed marker with key = " + key)
      

  get_recent_purchases: ->

    $.ajax "/map/query.json",
      type: "GET"
      success: (data, status, xhr) =>
        console.log("AJAX, received new JSON data")
        @add_markers(data["markers"])
      error: (xhr, status, error) =>
        console.log(xhr)
        alert(error)
      #data:
        #last_query: @last_query_time
