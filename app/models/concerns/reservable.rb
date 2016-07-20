module Reservable
  extend ActiveSupport::Concern

  def openings(start_date, end_date)
    listings.merge(Listing.available(start_date, end_date))
  end

  def ratio_reservations_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    else # If there are no listings, return 0 as the ratio
      0
    end
  end

  class_methods do
    def highest_ratio_res_to_listings
      # Returns City/Neighborhood with max value (most number of reservations per listing)
      self.all.max do |a, b|
        a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
      end
    end

    def most_res
      # Returns City/Neighborhood with most number of reservations
      self.all.max {|a, b| a.reservations.count <=> b.reservations.count}
    end
  end
end
