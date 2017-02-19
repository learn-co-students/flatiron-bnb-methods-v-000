module Available

  module InstanceMethods
    def openings(start_date, end_date)

    search_range = (start_date.to_date .. end_date.to_date)
    openings = []


    self.listings.each do |listing|
      checkins = []
      checkouts = []

      listing.reservations.each do |reservation|
        checkins << reservation.checkin
        checkouts << reservation.checkout
      end

      openings << listing if !search_range.overlaps?(checkins.sort.first .. checkouts.sort.last)

    end

    openings
    end
  end

  module ClassMethods
    #knows the city with the highest ratio of reservations to listings
    def highest_ration_res_to_listings

    end

    #knows the city with the most reservations
    def most_res

    end
  end

end
