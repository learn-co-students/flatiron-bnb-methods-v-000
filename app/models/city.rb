class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

   def city_openings(startdate, enddate)
    startdate = Date.parse(startdate)
    enddate = Date.parse(enddate)
    available_listings = []
    listings.collect do |listing| 
      if listing.reservations.none? { |res|  res.checkin.between?(startdate, enddate) && res.checkout.between?(startdate, enddate) }
        available_listings << listing
      end
    end
    available_listings
  end

  def self.highest_ratio_res_to_listings
    popular_city = ""
    highest_ratio = 0
    self.all.each do |city|  
      denominator = city.listings.count
      numerator = city.reservations.count
      if denominator == 0 || numerator == 0
        next
      else
        popularity_ratio = numerator / denominator
        if popularity_ratio > highest_ratio
          highest_ratio = popularity_ratio
          popular_city = city
        end
      end
    end
    popular_city
  end

  def self.most_res
    sorted_array = self.all.sort_by {|c| c.reservations.count}
    sorted_array.last
  end

end

