class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    listings.between_dates(start_date, end_date)
  end

  def res_to_listings_ratio
    if listings.any?
      total_reservations.to_f / listings.count.to_f
    else
      0
    end
  end
  
  def total_reservations
    if listings.any?
      listings.reduce(0) { |total, listing| listing.reservations.count + total }
    else
      0
    end
  end

  def with_listings
    
  end

  class << self
    def highest_ratio_res_to_listings
      all.max { |a,b| a.res_to_listings_ratio <=> b.res_to_listings_ratio }
    end

    def most_res
      all.max { |a,b| a.total_reservations <=> b.total_reservations }
    end

    def has_listings
      all.select { |city| city.listings.any? }
    end

  end
end

