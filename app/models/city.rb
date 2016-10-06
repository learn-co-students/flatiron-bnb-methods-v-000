require 'concerns/extra_reservation_info'

class City < ActiveRecord::Base
  include ReservationHelpers::InstanceMethods
  extend ReservationHelpers::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def dates_overlap?(start1, end1, start2, end2)
  	(start1..end1).overlaps?(start2..end2)
  end

  def all_reservations_for_city
  	city_reservations = []
  	self.listings.each do |listing|
  		city_reservations << listing.reservations
  	end
  	city_reservations.flatten
  end

  def city_openings(date1, date2)
  	listings_open = []
  	self.listings.each do |listing|
  		if listing.reservations.empty?
  			listings_open << listing
  		else
  			reservations_with_no_conflict = 0
  			listing.reservations.each do |reservation|
  				reservations_with_no_conflict = 0
  				if !dates_overlap?(reservation.checkin, reservation.checkout, date1, date2)
  					reservations_with_no_conflict += 1
  					puts "reservation has no conflict"
  				end
  			end
  		end
  		if reservations_with_no_conflict == listing.reservations.count
  			puts "listing has no conflict"
  			listings_open << listing
  			puts "open #{listings_open}"
  		end
  	end
  	puts "final open #{listings_open}"
  	listings_open
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

  def ratio_res_to_listings
  	total_res = self.all_reservations_for_city.count
  	total_listings = self.listings.count
  	ratio = total_res / total_listings
  end

  def self.highest_ratio_res_to_listings
  	city_with_highest_ratio = self.all.first
  	max_ratio = city_with_highest_ratio.ratio_res_to_listings
  	self.all.each do |city|
  		if city.ratio_res_to_listings > max_ratio
  			city_with_highest_ratio = city
  			max_ratio = city.ratio_res_to_listings
  		end
  	end
  	city_with_highest_ratio
  end


end

