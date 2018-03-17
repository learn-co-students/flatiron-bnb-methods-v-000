require 'pry'

class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(user_checkin, user_checkout)
      @openings = []
      @reserved = []

      Reservation.all.each do |reservation|
        if (user_checkin.to_date >= reservation.checkout) && (user_checkout.to_date <= reservation.checkin)
          @reserved << reservation
        end
      end

      Listing.all.each do |listing|
        if !@reserved.include?(listing)
          @openings << listing
        end
        @openings
      end
  end

  def self.highest_ratio_res_to_listings

    listings_by_city = {}  #listings by city (new york: 4  san diego: 3   etc.)
    reservation_cities = [] #list of reservations by city  [new york, new york, san diego]

    City.all.each do |city| #getting listings by city
      listings_by_city[city.name] = city.listings.length
    end

    Reservation.all.each do |reservation| #getting num of reservations per city
      list = Listing.all.find_by_id(reservation.listing_id)
      city = City.find_by_id(list.neighborhood.city_id)
      reservation_cities << city
    end

    find_ratio = {}

    listings_by_city.each do |key, value|
      total = reservation_cities.select {|i| i.name == key }
      if total.length > 0 && value > 0
        find_ratio[key] = total.length.to_f / value.to_f
      else
        find_ratio[key] = 0
      end
    end

    winner = find_ratio.max_by { |k, v| v }
    answer = City.find_by(name: winner[0])
  end

  def self.most_res

    arr = []
    Reservation.all.each do |reservation|
      listing = Listing.find_by_id(reservation.listing_id)
      neighborhood = Neighborhood.find_by_id(listing.neighborhood_id)
      city = City.find_by_id(neighborhood.city_id)
      arr << city
    end

    freq = arr.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    arr.max_by { |v| freq[v] }

  end

end
