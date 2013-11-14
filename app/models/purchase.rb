class Purchase < ActiveRecord::Base
  
  # This returns all purchases received within the last "seconds" seconds
  def self.recent(seconds)
    # Dummy data
    (1..5).collect do |i|
      Purchase.new(id: rand(9999999), name: "Name-#{rand(9999)}",
               lat: rand(160)-80, lng: rand(360)-180, price: rand(40)+10)
    end
  end
end
