class Purchase < ActiveRecord::Base
  
  # This returns all Purchases received recently
  #
  # params[:seconds] = number of seconds of recent data to pull
  # params[limit] = maximum number of Purchases to return
  def self.recent(params)
    # Dummy data
    (1..5).collect do |i|
      Purchase.new(id: rand(9999999), name: "Name-#{rand(9999)}",
               lat: rand(160)-80, lng: rand(360)-180, price: rand(40)+10)
    end
  end
end
