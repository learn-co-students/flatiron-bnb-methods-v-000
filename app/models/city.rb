class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
  	openings = []
  	self.listings.each do |listing|
  		if listing.available?(checkin, checkout)
  			openings << listing
  		end
  	end
  	openings
  end

  def self.highest_ratio_res_to_listings
  	high = 0
  	highest_city = nil
  	self.all.each do |city|
  		listings = city.listings.count
  		reservations = 0
  		city.listings.all.each do |listing|
  			reservations += listing.reservations.count
  		end
  		if listings > 0
  			ratio = reservations / listings
  			if ratio > high 
  				highest_city = city
  				high = ratio 
  			end
  		end
  	end
  	highest_city
  end

  def self.most_res
  	highest_city = nil
  	most_reservations = 0
  	self.all.each do |city|
  		city.listings.all.each do |listing|
  			reservations = listing.reservations.count 
  			if reservations > most_reservations
  				most_reservations = reservations
  				highest_city = city
  			end
  		end
  	end
  	highest_city
  end
end

