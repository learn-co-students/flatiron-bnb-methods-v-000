module Reservable
  module ClassMethods
    def highest_ratio_res_to_listings
      all.max { |a, b| a.res_to_listings <=> b.res_to_listings }
    end

    def most_res
      all.max { |a, b| a.reservations.count <=> b.reservations.count }
    end
  end

  module InstanceMethods
    def res_to_listings
      return 0 if listings.blank?
      reservations.count.to_f / listings.count.to_f
    end

    def openings(start_date, end_date)
      listings.available(start_date, end_date)
    end
  end
end
