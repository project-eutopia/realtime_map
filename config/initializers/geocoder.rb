# config/initializers/geocoder.rb
Geocoder.configure(

  # geocoding service
  :lookup => :google,

  # to use an API key
  #:api_key => "...",

  # geocoding service request timeout, in seconds (default 3)
  :timeout => 5,

  # set default units to kilometers
  :units => :km,

  # caching
  #:cache => Dalli::Client.new('localhost:3000', { :namespace => "realtime_map", :compress => true })
)
