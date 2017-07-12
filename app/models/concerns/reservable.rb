module Reservable

  module InstanceMethods
    def openings(checkin, checkout)
      listings.find_all do |listing|
        listing.reservations.all? do |res|
           (checkin.to_datetime >= res.checkout) || (checkout.to_datetime <= res.checkin)
        end
      end
    end

    def res_to_listings_ratio
      if listings.count > 0
        reservations.count.to_f / listings.count.to_f
      else
        0
      end
    end
  end

  module ClassMethods
    def highest_ratio_reservations_to_listings
      all.max {|a, b| a.res_to_listings_ratio <=> b.res_to_listings_ratio}
    end

    def most_reservations
      all.max {|a, b| a.reservations.count <=> b.reservations.count}
    end
  end
end
