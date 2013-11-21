class Purchase < ActiveRecord::Base
  COLORS = ['#FF2222', '#DDDD00', '#00BB22', '#000099', '#6644DD']
  DEFAULT_MAX_RECENT_PURCHASES = 100
  DEFAULT_QUERY_SECONDS = 60
  
  # This returns all Purchases received recently
  #
  # params[:start_time] = Time.now() at start of session
  # params[:query_time] = Time.now() for the current query
  # params[:seconds] = number of seconds of recent data to pull
  # params[:limit] = maximum number of Purchases to return
  def self.recent(params)
    # Hash default values
    params.reverse_merge!( seconds: DEFAULT_QUERY_SECONDS,
                           limit: DEFAULT_MAX_RECENT_PURCHASES,
                           session_start_time: Time.now(),
                           query_time: Time.now() )
    
    # Dummy data
    (1..10).collect do |i|
      Purchase.new(id: rand(9999999),
                   name: "Name-#{rand(9999)}",
                   session_start_time: params[:start_time],
                   purchase_time: params[:query_time] + params[:seconds]*rand(100)/100.0,
                   lat: rand(160)-80,
                   lng: rand(360)-180,
                   price: rand(40)+10,
                   store_id: rand(5))
    end
  end
  
  def radius
    price
  end
  
  def color
    COLORS[store_id]
  end
  
  def circle_data
    return {lng: lng,
          lat: lat,
          delay: (purchase_time - session_start_time),
          radius: radius,
          store_id: store_id,
          color: color,
          id: id}
  end
end
