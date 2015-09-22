class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
  
  # Returns all of the available apartments in a city, given the date range
  def city_openings(start_date, end_date)
    reservations.collect do |r|
      booked_dates = r.checkin..r.checkout
      unless booked_dates === start_date || booked_dates === end_date
        r.listing
      end
    end
  end

  # Returns city with highest ratio of reservations to listings
  def self.highest_ratio_res_to_listings
    popular_city = City.create(:name => "There is no popular city")
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
          popular_city = city
        end
      end
    end
    popular_city
  end

  # Returns city with most reservations
  def self.most_res
    most_reservation = "currently unknown"
    total_reservation_number = 0
    self.all.each do |city|
      city_reservation_number = city.reservations.count
      if city_reservation_number > total_reservation_number
        total_reservation_number = city_reservation_number
        most_reservation = city
      end
    end
    most_reservation
  end

end

