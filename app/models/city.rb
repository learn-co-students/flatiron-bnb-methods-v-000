class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings 

  def city_openings(start_date, end_date)
    available_reservations = []
    listings.each do |listing|
      available = listing.reservations.all? do |res|
        Date.parse(start_date) >= res.checkout || Date.parse(end_date) <= res.checkin
      end
      if available 
        available_reservations << listing
      end 
    end
    available_reservations
  end  

  def self.highest_ratio_res_to_listings
    City.all.max_by do |city|
      res = city.reservations.count 
      city_listings = city.listings.count 
      res.to_f/city_listings
    end 
  end 

  def self.most_res

  end 

end
