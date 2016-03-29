class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date_start, date_end)
    self.listings.select do |listing|
      !listing.reservations.any? do |reservation|
        (Date.parse(date_start.to_s) - Date.parse(reservation.checkout.to_s)) * (Date.parse(reservation.checkin.to_s) - Date.parse(date_end.to_s)) >= 0
      end
    end
  end

  def self.highest_ratio_res_to_listings
    sorted_cities = City.all.sort do |x,y|
      res_to_listings_ratio(y) <=> res_to_listings_ratio(x)
    end
    sorted_cities.first
  end

  def self.res_to_listings_ratio(city)
    number_res(city) / city.listings.size
  end

  def self.most_res
    sorted_cities = City.all.sort do |x,y|
      number_res(y) <=> number_res(x)
    end
    sorted_cities.first
  end

  def self.number_res(city)
    number_of_reservations = 0
    city.listings.each do |listing|
      number_of_reservations += listing.reservations.size
    end
    number_of_reservations
  end

end
