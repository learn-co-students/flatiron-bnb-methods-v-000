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

    def reservations_count
      x_reservations = 0
      self.listings.each do |listing|
        x_reservations += listing.reservations.count
      end
      x_reservations
    end


  end

  module ClassMethods
    #knows the city with the highest ratio of reservations to listings
    def highest_ratio_res_to_listings
      x_ratio = 0.0
      highest_ratio_res_to_listings = nil

      self.all.each do |x|
        if x_ratio < x.reservations_count/x.listings.count.to_f
          x_ratio = x.reservations_count/x.listings.count.to_f
          highest_ratio_res_to_listings = x
        end
      end
      highest_ratio_res_to_listings
    end

    #knows the city with the most reservations
    def most_res

    end
  end

end
