# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Load the map once the window is done loading by calling controller
$(document).ready ->
  window.box = new window.MapBox("map-canvas", window.data_json, 15)
  