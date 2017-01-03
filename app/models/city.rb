class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
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

  	self.all.each do |city|
  		city.listings.each do |l|
  			if city_res_count < l.reservations.count
  				city_res_count = l.reservations.count
  				highest_city = city
  			end
  		end
  	end
  	highest_city
  end

  def self.most_res
  	city_res_count = 0
  	most_res = nil

  	self.all.each do |city|
  		city.listings.each do |l|
  			if city_res_count < l.reservations.count
  				city_res_count = l.reservations.count
  				most_res = city
  			end
  		end
  	end
  	most_res
  end

end

