module Available

  module InstanceMethods
    def openings(date1, date2)
      listings.select do |listing|
        listing.reservations.each do |reservation|
          ((reservation.checkin.to_date)..(reservation.checkout.to_date)) == ((date1.to_date)..(date2.to_date))
        end
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
    def most_res
      all.max {|a, b| a.reservations.count <=> b.reservations.count}
    end

    def highest_ratio_res_to_listings
      all.max {|a, b| a.ratio_res_to_listings <=> b.ratio_res_to_listings}
    end
  end

end
