module Stats
  module InstanceMethods

    def openings(start_date, end_date)
      self.listings.reject do |listing|
        listing.reservations.any? do |reservation|
          start_date.to_date < reservation.checkout && end_date.to_date > reservation.checkin
        end
      end
    end
    def res_overlap?(start_date, end_date)
      listing.reservations.any? do |reservation|
        start_date <= reservation.checkout && end_date >= reservation.checkin
      end
    end

  end

  module ClassMethods
    def most_res
      all.max do |a, b|
        a.reservations.size <=> b.reservations.size
      end
    end

    def highest_ratio_res_to_listings
      areas = all.reject {|area| area.reservations.size == 0 || area.listings.size == 0}
      areas.max do |a, b|
        a.reservations.size / a.listings.size <=> b.reservations.size / b.listings.size
      end
    end
  end
end
