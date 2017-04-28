class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

 	def city_openings(startdate, enddate)
		city_openings = []
		listings.each do |listing|
			city_openings << listing if !(listing.reservations.any? {|res| 
			res.checkin.to_s <= enddate && res.checkout.to_s >= startdate})
		end
		city_openings
  	end

  	def self.highest_ratio_res_to_listings
  		cities = self.all.sort_by {|city| city.reservations.count.to_f / city.listings.count.to_f}
  		cities.reverse.first
  	end

  	def self.most_res
  		cities = self.all.sort_by {|city| city.reservations.count}
  		cities.reverse.first
  	end
end

