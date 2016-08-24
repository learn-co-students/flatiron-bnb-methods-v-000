class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings starting, ending
    binding.pry
    # self.listings.map{|listing| listing.reservations}
    reservations = []

    self.listings.each do |listing|
      reservations << listing.reservations
    end
  end

  def self.highest_ratio_res_to_listings
    binding.pry
    map do |city|
       city.listings.map{|listing| listing.reservations}.flatten.count / city.listings.flatten.count
    end
  end

end

