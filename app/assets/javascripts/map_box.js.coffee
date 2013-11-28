# This class holds all the things needed in the map:  the map itself, data used
# for displaying on the map, and the loop that updates the map and the database
# check
class window.MapBox
  constructor: (initial_json) ->
    @markers = {}
    @map = null
    
    @fps = initial_json["fps"]

    @loadMap()
    @client_side_start_time = Date.now()
    
    # This event called when a marker completely fades out, and needs to be removed
    window.$map_div.on "remove_marker", (event, marker) =>
      delete @markers[marker.id]
      console.log("Removed marker with key = " + marker.id)
    
    @add_markers(initial_json["markers"])

    # This interval periodically will call the server for more data to display
    setInterval ( =>
      @get_recent_purchases()
    ), initial_json["seconds_between_calls"]*1000
    
  
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
      for marker in json
        do (marker) =>
          setTimeout ( =>
            @markers[marker.id] = new Marker(marker.id, marker.lat, marker.lng, marker.radius, marker.color, @map, @fps)
            console.log("Added new marker: " + @markers[marker.id])
          ), (@client_side_start_time + marker.delay_ms) - Date.now()
  
  
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
