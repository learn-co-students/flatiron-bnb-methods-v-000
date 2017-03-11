class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    self.listings.select{ |listing| listing.available?(start_date, end_date) }
  end


  def self.highest_ratio_res_to_listings
    self.all.max_by{ |city| city.ratio_reservations_to_listings }
  end

  def ratio_reservations_to_listings
    listings_count = self.listings.count
    reservations_count = self.listings.map{ |listing| listing.reservations.count}.reduce(:+)
    reservations_count / listings_count
  end

  
end

