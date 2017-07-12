class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

 def neighborhood_openings(start_date, end_date)
    listings.collect do |listing|
      listing if listing.reservations.none? do |reservation|
        Date.parse(start_date) <= reservation.checkin && Date.parse(end_date) <= reservation.checkout
      end
    end
  end 

  def self.highest_ratio_res_to_listings
    city_hash = {}
    self.all.each do |city|
      listings_count = city.listings.count
      reservations_count = 0
      city.listings.each do |listing|
        reservations_count += listing.reservations.count
      end 
      if reservations_count != 0 && listings_count !=0 
        ratio = reservations_count/listings_count
        city_hash[city] = ratio
      end 
    end
    city_hash.key(city_hash.values.max)
  end

  def self.most_res 
    city_hash = {}
    self.all.each do |city|
      reservations_count = 0
      city.listings.each do |listing|
        reservations_count += listing.reservations.count
      end 
      city_hash[city] = reservations_count
    end
    city_hash.key(city_hash.values.max)
  end 
end
