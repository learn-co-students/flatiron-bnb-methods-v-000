class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    Listing.all.each do |listing|
      listing_reservations(listing, date1, date2)
    end
  end

  def self.highest_ratio_res_to_listings
    max_city(city_ratios)
  end

  def self.most_res
    max_city(reservations_by_city)
  end

private

  def listing_reservations(listing, date1, date2)
    openings = []
    listing.reservations.each do |reservation|
      if !(date1 <= checkout(reservation)) and (date2 <= checkin(reservation))
        openings << listing
      end
    end
  end

  def checkin(reservation)
    reservation.checkin.strftime
  end

  def checkout(reservation)
    reservation.checkout.strftime
  end

  def self.city_ratios
    city_ratios = {}
    reservations_by_city.each do |city, count|
      city_ratios[city] = count.to_f/listings_by_city(city).count.to_f
    end
    city_ratios
  end

  def self.reservations_by_city
    city_reservations = {}
    cities.each do |city|
      city_reservations[city.name] = city_name_of_reservation(city).count
    end
    city_reservations
  end

  def self.listings_by_city(city)
    city_listings = {}
    cities.each do |x|
      city_listings[x.name] = x.listings
    end
    city_listings[city]
  end

  def self.city_name_of_reservation(city)
    reservation_by_city = []
    Reservation.all.each do |r|
      if r.listing.neighborhood.city.name == city.name
        reservation_by_city << r
      end
    end
    reservation_by_city
  end

  def self.cities
    City.all
  end

  def self.max_city(hash)
    max = hash.values.max
    city = hash.select { |k, v| v == max}
    City.find_by(name: city.keys)
  end

end
