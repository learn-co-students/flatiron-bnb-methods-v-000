class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  # def self.most_res
  #   max = 0
  #   hood = nil
  #   City.all.map do |city|
  #     city.listings.each do |listing|
  #       if listing.reservations.count > max
  #         @hood = Neighborhood.find(listing.neighborhood_id)
  #         @max = listing.reservations.count
  #       end
  #     end
  #     @city = City.find(@hood.city_id)
  #     @city
  #   end
  # end

end
