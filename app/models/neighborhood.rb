class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin, checkout)
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
  	highest_hood = nil
  	self.all.each do |hood|
  		listings = hood.listings.count
  		reservations = 0
  		hood.listings.all.each do |listing|
  			reservations += listing.reservations.count
  		end
  		if listings > 0
  			ratio = reservations / listings
  			if ratio > high 
  				highest_hood = hood
  				high = ratio 
  			end
  		end
  	end
  	highest_hood
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
