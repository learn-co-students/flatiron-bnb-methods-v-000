class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(starting, ending)
    results = []
    start_date = Date.parse(starting)
    end_date = Date.parse(ending)
    self.listings.each do |listing|
      valid = true
      listing.reservations.each do |reservation|
        if !(reservation.checkin > end_date || reservation.checkout < start_date)
          valid = false
        end
      end
      if valid
        results << listing
      end
    end
    results
  end

  def self.highest_ratio_res_to_listings
    high = 0
    return_city = nil
    City.all.each do |city|
      listings = city.listings.count
      reservations = 0
      city.listings.all.each do |listing|
        reservations += listing.reservations.count
      end
      if listings > 0
        ratio = reservations / listings
        if ratio > high
          return_city = city
          high = ratio
        end
      end
    end
    return_city
  end

  def self.most_res
    high = 0
    return_city = nil
    City.all.each do |city|
      reservations = 0
      city.listings.all.each do |listing|
        reservations += listing.reservations.count
      end
      if reservations > high
        return_city = city
        high = reservations
      end
    end
    return_city
  end

end
