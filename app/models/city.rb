class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(starting, ending)
    starting_date = Date.parse(starting)
    ending_date = Date.parse(ending)
    available_listings = []

    listings.each do |listing|
      unavailable = listing.reservations.any? do |reservation|
        starting_date.between?(reservation.checkin, reservation.checkout) || ending_date.between?(reservation.checkin, reservation.checkout)
      end
      unless unavailable
        available_listings << listing
      end
    end
    return available_listings
  end

  def self.highest_ratio_res_to_listings
    popular_city = "There is no popular city."
    popularity_ratio = 0.00
    self.all.each do |city|
      denominator = city.listings.count
      numerator = city.reservations.count
      if numerator == 0 || denominator == 0
        return popular_city
      else
        city_ratio = numerator / denominator
        if city_ratio > popularity_ratio
          popularity_ratio = city_ratio
          popular_city = city
        end
      end
    end
    popular_city
  end

  def self.most_res
    most_reservations_city = "Not available."
    reservation_count = 0
    self.all.each do |city|
      reservations = city.reservations.count
      if reservations > reservation_count
        reservation_count = reservations
        most_reservations_city = city
      end
    end
    most_reservations_city
  end
end

