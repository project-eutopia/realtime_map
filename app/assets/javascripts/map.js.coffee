# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Load the map once the window is done loading by calling controller
window.onload = ->
  window.box = new @MapBox("map-canvas", window.data_json, 20)
  