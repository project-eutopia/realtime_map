# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Load the map once the window is done loading by calling controller
$(document).ready ->
  window.map_div_id = "map-canvas"
  window.$map_div = $( "#"+window.map_div_id )
  
  window.box = new window.MapBox(window.data_json)
