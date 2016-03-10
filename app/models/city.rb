class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
  	start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

  	self.listings.select do |listing|
  		listing.reservations.empty? ||
  		listing.reservations.all? do |reservation|
  			reservation.checkin >=end_date || reservation.checkout <= start_date
  		end
  	end
  end

  def self.highest_ratio_res_to_listings
  	
  	City.all.max_by do |city|
  		city.listings.inject(0) {|sum,listing| sum + listing.reservations.count} / city.listings.count
  	end

  end

  def self.most_res
  	City.all.max_by do |city|
  		city.listings.inject(0) { |sum, listing| sum + listing.reservations.count}
  	end
  end
  




end

