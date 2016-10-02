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
    cities = City.all
    city_reservations = {}
    city_listings = {}
    city_ratios = []

    res_cities

    cities.each do |c|
      city_res = []
      res_cities.each do |r|
        if r.name == c.name
          city_res << r
        end
      end
      city = c.name
      city_reservations[city] = city_res.count
      city_listings[city] = c.listings.count
    end

    city_ratios = {}
    city_reservations.each do |city, count|
      city_ratios[city] = count.to_f/city_listings[city].to_f
    end
    max = city_ratios.values.max
    city = city_ratios.select { |k, v| v == max }
    City.find_by(name: city.keys)
  end

  def self.most_res

  end

private

  def self.res_cities
    reservations = Reservation.all
    reservations.collect do |r|
      r.listing.neighborhood.city
    end
  end

end
