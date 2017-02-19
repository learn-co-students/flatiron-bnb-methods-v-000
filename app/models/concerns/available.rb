module Available

  module InstanceMethods
    def openings(start_date, end_date)
      listings.select do |listing|
        listing.reservations.each do |reservation|
          ((reservation.checkin.to_date)..(reservation.checkout.to_date)) == ((start_date.to_date)..(end_date.to_date))
        end
      end
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
