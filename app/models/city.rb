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
    high = 0
    highest_city = nil
    self.all.each do |city|
      listings = city.listings.count
      reservations = 0
      city.listings.all.each do |listing|
        reservations += listing.reservations.count
      end
      if listings > 0
        ratio = reservations / listings
        if ratio > high
          highest_city = city
          high = ratio
        end
      end
    end
    highest_city
  end

  def self.most_res
    most_res = 0
    city_most_res = nil
    self.all.each do |city|
      reservations = 0
      city.listings.all.each do |listing|
        reservations += listing.reservations.count
      end
      if most_res < reservations
        most_res = reservations
        city_most_res = city
      end
    end
    city_most_res
  end

end
