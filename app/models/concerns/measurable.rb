class Measurable

  module InstanceMethods
    # total reservations per city
    def total_reservations
      self.listings.collect {|listing| listing.reservations.count}.sum
    end

    # Returns true if listing is available
    def available?(startdate, enddate)
      self.reservations.none? do |reservation|
        booked_range = reservation.checkin .. reservation.checkout
        booked_range.cover? startdate or booked_range.cover? enddate
      end
    end
  end

  module ClassMethods

    # knows the place with the highest ratio of reservations to listings
    def highest_ratio_res_to_listings
      self.all.inject { |memo, place| memo.total_reservations > place.total_reservations ? memo : place }
    end

    # knows the place with the most reservations
    def most_res
      self.all.inject { |memo, place| memo.total_reservations > place.total_reservations ? memo : place }
    end

  end

end
