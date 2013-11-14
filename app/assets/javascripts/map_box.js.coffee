# This class holds all the things needed in the map:  the map itself, data used
# for displaying on the map, and the loop that updates the map and the database
# check
class @MapBox
  constructor: ->
    @markers = {}
    @map = null
  
  loadMap: (div_id) ->

    mapOptions =
      zoom: 2
      center: new google.maps.LatLng(20, 8)
      mapTypeId: google.maps.MapTypeId.ROADMAP

    # Build the map
    @map = new google.maps.Map(document.getElementById(div_id), mapOptions)


  
  add_markers: (json) ->
    #if @map != null and @okay_to_update()
    #  now = new Date()
    #  console.log("now = " + now + " vs then " + time)
    #  
    #  marker = new Marker(lat, lng, radius, store, color, @map)
    #  if @store != "" and @store != null and @store != store.toString()
    #    marker.googleMarker.setVisible(false)
    #  @markers.add(marker)
    
  update: ->
    #console.log(@markers.size()) # Check that we are really removing markers
    #if @okay_to_update()
    #  marker_node = @markers.head
    #  while marker_node isnt null
    #    if marker_node.obj.update() == true
    #      # Set the map to NULL and remove from our LinkedList to ensure this
    #      # finished marker will be garbage collected
    #      marker_node.obj.googleMarker.setMap(null)
    #      @markers.remove(marker_node)
    #    marker_node = marker_node.next

  database_get_new: ->

    #$.ajax "/map/database_get_new",
    #  type: "POST"
    #  data:
    #    last_query: @last_query_time
    #  success: ->
    #    alert
    #  error: ->
    #    # This AJAX call... we should have validation of user to be able to call
    #    console.log("Error calling /map/database_get_new")
