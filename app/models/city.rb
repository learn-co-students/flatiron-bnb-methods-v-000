class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def dates_overlap?(start1, end1, start2, end2)
  	(start1..end1).overlaps?(start2..end2)
  end

  def all_listings_for_city
  	city_listings = []
  	self.neighborhoods.each do |neighborhood|
  		city_listings << neighborhood.listings
  	end
  	city_listings.flatten.compact!
  end

  def all_reservations_for_city
  	city_reservations = []
  	self.city_listings.each do |listing|
  		city_reservations << listing.reservations
  	end
  	city_reservations.flatten.compact!
  end

  def city_openings(date1, date2)
  	listings_open = []
  	self.all_listings_for_city.each do |listing|
  		if listing.reservations.empty?
  			listings_open << listing
  		else
  			listing.reservations.each do |reservation|
  				reservations_with_no_conflict = 0
  			if !dates_overlap?(reservation.checkin, reservation.checkout, date1, date2)
  				reservations_with_no_conflict += 1
  			end
  		end
  		if reservations_with_no_conflict == listing.reservations.count
  			listings_open << listing
  		end
  	end
  end

  def self.most_res
  	city_with_max_reservations = self.all.first
  	max_reservations = city_with_max_reservations.all_reservations_for_city.count
  	
  	self.all.each do |city|
  		if city.all_reservations_for_city.count > max_reservations
  			city_with_max_reservations = city
  			max_reservations = city.all_reservations_for_city.count
  		end
  	end
  	city_with_max_reservations
  end

  def reservations_to_listings_ratio(city)	
  	city.all_reservations_for_city.count / city.all_listings_for_city.count
  end

  def self.highest_ratio_res_to_listings
  	city_with_highest_ratio = self.all.first
  	highest_ratio = reservations_to_listings_ratio(city_with_highest_ratio)
  	self.all.each do |city|
  		if reservations_to_listings_ratio(city) > highest_ratio
  			city_with_highest_ratio = city
  			highest_ratio = reservations_to_listings_ratio(city)
  		end
  	end
  	city_with_highest_ratio
  end

end
end

