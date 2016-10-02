class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    @openings = []
    @listings = Listing.all
    listings.each do |listing|
      listing.reservations.each do |reservation|
        checkin = reservation.checkin.strftime
        checkout = reservation.checkout.strftime
        if !(date1 <= checkout) and (date2 <= checkin)
          @openings << listing
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    city_reservations = {}
    city_listings = {}
    city_ratios = []

    name_cities.each do |city|
      city_reservations(city)
      binding.pry
      #reservations_of_city should be city_reservations(city) once it returns properly
      city_reservations[city] = reservations_of_city.count
      city_listings[city] = c.listings.count
    end





    city_ratios = {}
    @@city_reservations = city_reservations
    @@city_reservations.each do |city, count|
      city_ratios[city] = count.to_f/city_listings[city].to_f
    end

    max_city(city_ratios)
  end

  def self.most_res


    #max_city(@city_reservations)
    max = @@city_reservations.values.max
    city = @@city_reservations.select { |k, v| v == max }

    City.find_by(name: city.keys)
  end

private

  def self.name_cities
    cities = City.all
    cities.each do |c|
      c.name
    end
  end

  def self.city_reservations(city)
    if city_name_of_reservation == city
      #need to figure out how to pass reservation to reservations of city, r_city doesn't exist
        reservations_of_city << r_city
    end
  end

  def self.city_name_of_reservation
    list_reservations.each do |r|
      r.listing.neighborhood.city.name
    end
  end

  def self.list_reservations
    Reservation.all
  end

  def self.max_city(array)
    max = array.values.max
    city = array.select { |k, v| v == max}
    City.find_by(name: city.keys)
  end

end
