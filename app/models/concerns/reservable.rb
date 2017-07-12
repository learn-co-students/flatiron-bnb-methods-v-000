module Reservable
  extend ActiveSupport::Concern

  included do
    def city_openings(begin_date, end_date)
      find_openings(begin_date, end_date)
    end

    def neighborhood_openings(begin_date, end_date)
      find_openings(begin_date, end_date)
    end

    def find_openings(begin_date, end_date)
      @openings = []
      checkin_date = Date.parse(begin_date)
      checkout_date = Date.parse(end_date)
      listings.each do |listing|
        @openings << listing unless listing.reservations.any? do |reservation|
          checkin_date.between?(reservation.checkin, reservation.checkout) || checkout_date.between?(reservation.checkin, reservation.checkout)
        end
      end
      @openings
    end

    def res_to_listings_ratio
      total_reservations.to_f / listings.count.to_f
    end

    def total_reservations
      listings.reduce(0) { |total, listing| listing.reservations.count + total }
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      has_listings.max { |a,b| a.res_to_listings_ratio <=> b.res_to_listings_ratio }
    end

    def has_listings
      all.select { |city| city.listings.any? }
    end

    def most_res

      locations = {}
      self.all.collect do |location|
        locations[location.name] = location.listings.collect {|listing|listing.reservations.count}.inject {|sum, count| sum + count }
      end
      most_res_location_name = locations.key(locations.values.compact.max)
      self.find_by(name: most_res_location_name)
    end

  end
end
