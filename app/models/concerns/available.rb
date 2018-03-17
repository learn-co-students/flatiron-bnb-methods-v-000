module Available
  module InstanceMethods

    def openings(start_date, end_date)
      self.listings.each do |listing|
        listing.reservations.where(":checkin >= ? AND :checkout <= ? AND :status != ?", start_date, end_date, "accepted")
      end
    end

    def ratio_res_to_listings
      if listings.count > 0
        reservations.count.to_f / listings.count.to_f
      else
        0
      end
    end
  end

  module ClassMethods

    def highest_ratio_res_to_listings
      all.max do |a, b|
        a.ratio_res_to_listings <=> b.ratio_res_to_listings
      end
    end

    def most_res
      all.max do |a, b|
        a.reservations.count <=> b.reservations.count
      end
    end
  end
end
