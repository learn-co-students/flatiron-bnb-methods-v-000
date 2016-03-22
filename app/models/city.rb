class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(startDate, endDate)
  	range = ((Date.parse startDate)..(Date.parse endDate))
  	
  	listings.select do |listing|
  		listing.reservations.empty? || listing.reservations.any? do |res|
  			!range.cover?(res.checkin) && !range.cover?(res.checkout)
  		end
  	end
  end
  
  def self.highest_ratio_res_to_listings
    self.all.max_by do |city|
      city.total_reservations.to_f / (city.listings.length + 1).to_f
    end
  end
  
  def self.most_res
    self.all.max_by do |city|
      city.total_reservations
    end
  end
  
  def total_reservations
    if listings.empty?
      0
    else
      listings.max do |l1, l2|
        l1.reservations.length <=> l2.reservations.length
      end.reservations.length
    end
  end
  
end

