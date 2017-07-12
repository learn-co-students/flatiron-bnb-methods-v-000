module Statistics
  module InstanceMethods
    def sum_of_reservations
      listings.collect { |listing| listing.reservations.count }.sum
    end

    def ratio_reservations_to_listings
      return 0 if listings.count.zero?
      sum_of_reservations.to_f / listings.count
    end

    def openings(start_date, end_date)
      listings.select do |listing|
        listing.available?(Date.parse(start_date),
                            Date.parse(end_date))
      end
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      all.sort do |a, b|
        b.ratio_reservations_to_listings <=> a.ratio_reservations_to_listings
      end.first
    end

    def most_res
      all.sort { |a, b| b.sum_of_reservations <=> a.sum_of_reservations }.first
    end
  end
end