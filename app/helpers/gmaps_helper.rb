# Helper functions for setting up the Google Maps API library
module GmapsHelper

  def google_maps_api_key
    "AIzaSyCK9cDnKp3uvUotbN7NiR3OYpywagCSIYw"
  end
  
  def google_api_url
    "http://maps.googleapis.com/maps/api/js"
  end
  
  def google_api_access
    "#{google_api_url}?key=#{google_maps_api_key}&libraries=geometry&sensor=false"
  end
  
  def google_maps_api
    content_tag(:script,:type => "text/javascript", :src => google_api_access) do
    end
  end
end