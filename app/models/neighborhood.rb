class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(start, end_d)
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
  	highest_neighborhood = nil

  	self.all.each do |neighborhood|
  		neighborhood.listings.each do |listing|
  			if res < listing.reservations.count
  				res = listing.reservations.count
  				highest_neighborhood = neighborhood
  			end
  		end
  	end
  	highest_neighborhood
  end


 def self.most_res 
  	highest_res = 0
  	highest_res_neighborhood = nil
  	neighborhood_reservations = []
	  	self.all.each do |neighborhood|
	  		neighborhood.listings.each do |listing|
	  			neighborhood_reservations << listing.reservations
	  			neighborhood_reservations
	  		end 
			if neighborhood_reservations.flatten.length > highest_res
			  	highest_res = neighborhood_reservations.length 
			  	highest_res_neighborhood = neighborhood 
		  	end 
		  	# binding.pry
	  	neighborhood_reservations.clear
  		end 
  	highest_res_neighborhood
  end 

end
