class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start, finish)
    all_listings = self.listings
    available = all_listings.select { |listing| listing.available?(start, finish) }
  end

  def self.highest_ratio_res_to_listings
    City.all.max_by do |city|
      city.res_to_listing_ratio
    end
  end

  def res_to_listing_ratio
    if self.listings.count != 0
      reservations.count / self.listings.count
    else
      return 0
    end
  end

  def self.most_res
    City.all.max_by do |city|
      city.reservations.count
    end
  end

end

