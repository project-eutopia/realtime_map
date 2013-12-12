class Purchase < ActiveRecord::Base
  
  geocoded_by :address, :latitude  => :lat, :longitude => :lng
  #after_validation :geocode
  
  COLORS = ['#FF2222', '#DDDD00', '#00BB22', '#000099', '#6644DD']
  DEFAULT_MAX_RECENT_PURCHASES = 100
  
  # This returns all Purchases received recently
  #
  # params[:start_time] = Time.now() at start of session
  # params[:query_time] = Time.now() for the start of the current query
  # params[:seconds] = number of seconds of recent data to pull
  # params[:limit] = maximum number of Purchases to return (optional)
  def self.recent(params)
    # Hash default values
    params.reverse_merge!( limit: DEFAULT_MAX_RECENT_PURCHASES )
    
    # Dummy data
    (1..params[:limit]).collect do |i|
      purchase = Purchase.new(id: rand(9999999),
                   name: "Name-#{rand(9999)}",
                   session_start_time: params[:start_time],
                   purchase_time: params[:query_time] + params[:seconds]*rand(1000)/1000.0,
                   address: "",
                   lat: rand(160)-80,
                   lng: rand(360)-180,
                   price: rand(40)+10,
                   fradulent_score: rand(100),
                   store_id: rand(5))
      # Can call geocode
      #purchase.geocode
      purchase
    end
  end
  
  def radius
    price
  end
  
  def color
    COLORS[store_id]
  end
  
  def marker_name
    if fradulent_score
      if fradulent_score < 10
        "ErrorMarker"
      elsif fradulent_score < 35
        "WarningMarker"
      else
        "BasicMarker"
      end
    else
      "BasicMarker"
    end
  end
  
  def circle_data
    return {lng: lng,
          lat: lat,
          delay_ms: 1000*(purchase_time - session_start_time),
          radius: radius,
          store_id: store_id,
          color: color,
          marker_name: marker_name,
          address: address,
          id: id}
  end
end
