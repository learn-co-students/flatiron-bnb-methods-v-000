class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(date_start, date_end)
    parsed_start = Date.parse(date_start)
    parsed_end = Date.parse(date_end)
    openings = []
    listings.each do |listing|
      blocked = listing.reservations.any? do |reservation|
        parsed_start.between?(reservation.checkin, reservation.checkout) || parsed_end.between?(reservation.checkin, reservation.checkout)
      end
      unless blocked
        openings << listing
      end
    end
    return openings
  end

  def self.highest_ratio_res_to_listings
    highest_city = "none"
    highest_ratio = 0.00
    self.all.each do |city|
      denominator = city.listings.count
      numerator = city.reservations.count
      if denominator == 0 || numerator == 0
        next
      else
        popularity_ratio = numerator / denominator
        if popularity_ratio > highest_ratio
          highest_ratio = popularity_ratio
          highest_city = city
        end
      end
    end
    highest_city
  end

  def self.most_res
    highest_city = "none"
    high_num = 0
    self.all.each do |city|
      city_size = city.reservations.size #this way only queries once
      if city_size > high_num
        highest_city = city
        high_num = city_size
      end
    end
    highest_city
  end

end