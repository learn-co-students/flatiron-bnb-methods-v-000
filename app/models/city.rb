class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start, end_d)
  	openings = []
  	start_date = DateTime.parse(start)
  	end_date = DateTime.parse(end_d)
  	self.listings.each do |listing|
  		if listing.reservations.none? { |reservation| start_date <= reservation.checkout && end_date >= reservation.checkin }
  			openings << listing
  		end 
  	end 
  	openings
  end


  def self.highest_ratio_res_to_listings
  	res = 0
  	highest_city = nil

  	self.all.each do |city|
  		city.listings.each do |listing|
  			if res < listing.reservations.count
  				res = listing.reservations.count
  				highest_city = city
  			end
  		end
  	end
  	highest_city
  end

  def self.most_res 
  	highest_res = 0
  	highest_res_city = nil
  	city_reservations = []
	  	self.all.each do |city|
	  		city.listings.each do |listing|
	  			city_reservations << listing.reservations
	  			city_reservations
	  		end 
			if city_reservations.flatten.length > highest_res
			  	highest_res = city_reservations.length 
			  	highest_res_city = city 
		  	end 
		  	# binding.pry
	  	city_reservations.clear
  		end 
  	highest_res_city
  end 

end

