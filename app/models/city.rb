class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
    city_listings = neighborhoods.map {|neighborhood| neighborhood.listings}.flatten
    open_listings = []
    city_listings.each do |listing|
      if listing.reservations.empty?
        open_listings << listing
      else
        listing.reservations.flatten.each do |reservation|
          if (Date.parse(checkin) > reservation.checkout || Date.parse(checkout) < reservation.checkin)
            open_listings << listing
          end
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    city_listing_size = {}
    city_reservation_size = {}
    res_to_listing_ratio = {}

    self.all.each_with_index do |city, index|
      city_listing_size[index] = city.neighborhoods.map {|neighborhood| neighborhood.listings}.flatten.size.to_f
    end

    self.all.each_with_index do |city, index|
      city_listings = city.neighborhoods.map {|neighborhood| neighborhood.listings}.flatten
      city_reservations = city_listings.map {|listing| listing.reservations}.flatten
      city_reservation_size[index] = city_reservations.size.to_f
    end

    self.all.each_with_index do |city, index|
      res_to_listing_ratio[index] = city_reservation_size[index]/city_listing_size[index]
    end
    self.all[res_to_listing_ratio.max_by {|k,v| v}.first]
  end

  def self.most_res
    city_reservation_size = {}
    self.all.each_with_index do |city, index|
      city_listings = city.neighborhoods.map {|neighborhood| neighborhood.listings}.flatten
      city_reservations = city_listings.map {|listing| listing.reservations}.flatten
      city_reservation_size[index] = city_reservations.size
    end
    self.all[city_reservation_size.max_by {|k,v| v}.first]
  end

end
