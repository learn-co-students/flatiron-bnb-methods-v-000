module Shareable

  module InstanceMethods
    def openings(start_date, end_date)
      listings.select do |listing|
        listing.reservations.all? do |reservation|
          start_date.to_date >= reservation.checkout || end_date.to_date <= reservation.checkin
        end
      end
    end

    def ratio_res_to_listings
      listings.count == 0 ? 0 : reservations.count.to_f / listings.count.to_f
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
