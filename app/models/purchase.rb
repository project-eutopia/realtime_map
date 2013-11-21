class Purchase < ActiveRecord::Base
  COLORS = ['#FF2222', '#DDDD00', '#00BB22', '#000099', '#6644DD']
  DEFAULT_MAX_RECENT_PURCHASES = 100
  
  # This returns all Purchases received recently
  #
  # params[:start_time] = Time.now() at start of session
  # params[:query_time] = Time.now() for the current query
  # params[:seconds] = number of seconds of recent data to pull
  # params[:limit] = maximum number of Purchases to return
  def self.recent(params)
    # Dummy data
    (1..10).collect do |i|
      Purchase.new(id: rand(9999999),
                   name: "Name-#{rand(9999)}",
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
          radius: radius,
          store_id: store_id,
          color: color,
          id: id}
  end
end
