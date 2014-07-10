class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  # Returns all of the available apartments in a city, given the date range
  def city_openings(start_date, end_date)
    openings = []
    self.listings.each do |listing|
      listing.reservations.each do |r|
        booked_dates = r.checkin..r.checkout
        unless booked_dates === start_date || booked_dates === end_date
          openings << listing
        end
      end
    end
    return openings
  end

  # Returns city with highest ratio of reservations to listings
  def self.highest_ratio_res_to_listings
    popular_city = "?"
    highest_ratio = 0.00
    self.all.each do |city|  
      denominator = city.listings.count
      numerator = find_res_count(city)
      popularity_ratio = numerator / denominator
      if popularity_ratio > highest_ratio
        highest_ratio = popularity_ratio
        popular_city = city
      end
    end
    return popular_city
  end

  # Returns city with most reservations
  def self.most_res
    most_reservation = "currently unknown"
    total_reservation_number = 0
    self.all.each do |city|
      city_reservation_number = find_res_count(city)
      if city_reservation_number > total_reservation_number
        total_reservation_number = city_reservation_number
        most_reservation = city
      end
    end
    return most_reservation
  end

  #helper for above class methods
  def find_res_count(city)
    res_count = 0
    city.listings.each do |listing|
      res_count += listing.reservations.count
    end
    return res_count
  end
end

