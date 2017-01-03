class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin, checkout)
  	openings = []
  	self.listings.each do |l|
  		if l.available?(checkin, checkout)
  			openings << l
  		end
  	end
  	openings
  end

  def self.highest_ratio_res_to_listings
  	city_res_count = 0
  	highest_city = nil

  	self.all.each do |neighborhood|
  		neighborhood.listings.each do |l|
  			if city_res_count < l.reservations.count
  				city_res_count = l.reservations.count
  				highest_city = neighborhood
  			end
  		end
  	end
  	highest_city
  end

  def self.most_res
  	city_res_count = 0
  	most_res = nil

  	self.all.each do |neighborhood|
  		neighborhood.listings.each do |l|
  			if city_res_count < l.reservations.count
  				city_res_count = l.reservations.count
  				most_res = neighborhood
  			end
  		end
  	end
  	most_res
  end
end
