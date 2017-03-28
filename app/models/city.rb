require 'pry'
require 'date'
class City < ActiveRecord::Base


  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def self.highest_ratio_res_to_listings
  	self.all.max_by do |city| 
  		reservation_count = city.listings.inject(0) { |sum, list| sum+=list.reservations.count }
  		listing_count = city.listings.count
  		(listing_count==0) ? 0 : (reservation_count/listing_count)
  	end
  end

  def self.most_res
  	self.all.max_by do |city| 
  		city.listings.inject(0) { |sum, list| sum+=list.reservations.count }
  	end
  end

  def city_openings(min, max)
  	self.listings.find_all do |listing|
  		listing.reservations.none? do |res| 
  			between_dates?(min:min, max:max, date:res.checkin) || between_dates?(min:min, max:max, date:res.checkout)
  		end
  	end
  end

  def between_dates?(min:, max:, date:) 	
  	Date.parse(date.to_s).between?(Date.parse(min.to_s), Date.parse(max.to_s))
  end

end

