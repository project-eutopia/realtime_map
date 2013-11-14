# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Load the map once the window is done loading by calling controller
window.onload = ->
  mapOptions =
    zoom: 2
    center: new google.maps.LatLng(20, 8)
    mapTypeId: google.maps.MapTypeId.ROADMAP

  # Build the map
  @map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions)
