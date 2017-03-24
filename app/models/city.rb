class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  # returns all the Listings that are available for the entire supplied date range.
  # i.e. all listings having no reservations that overlap the supplied date range.
  def city_openings(start_date, end_date)
    listings.reject { |listing|
      listing.reservations.detect { |reservation|
        reservation.checkin <= Date.parse(end_date) && reservation.checkout >= Date.parse(start_date)
      }
    }
  end

  # returns the City that has the most reservations per listing.
  def self.highest_ratio_res_to_listings
    highest_ratio_city = nil
    highest_ratio = 0.0
    City.all.each { |city|
      listing_count = city.listings.size
      reservation_count = city.listings.inject(0) { |res_count, listing| res_count + listing.reservations.size }
      city_ratio = reservation_count.to_f / listing_count.to_f
      if city_ratio > highest_ratio
        highest_ratio = city_ratio
        highest_ratio_city = city
      end
    }
    highest_ratio_city
  end

  # returns the City that has the most reservations.
  def self.most_res
    most_reservations_city = nil
    highest_reservations = 0
    City.all.each { |city|
      reservation_count = city.listings.inject(0) { |res_count, listing| res_count + listing.reservations.size }
      if reservation_count > highest_reservations
        highest_reservations = reservation_count
        most_reservations_city = city
      end
    }
    most_reservations_city
  end

end
