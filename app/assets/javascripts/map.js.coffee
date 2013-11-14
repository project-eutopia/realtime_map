# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Load the map once the window is done loading by calling controller
window.onload = ->
  window.box = new @MapBox
  window.box.loadMap("map-canvas")
  window.box.add_markers(window.purchases_json)
  window.box.drawing_loop(20)