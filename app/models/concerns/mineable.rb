module Mineable
  extend ActiveSupport::Concern

  def openings(start_date, end_date)
    date_range = (Date.parse(start_date)..Date.parse(end_date))
    listings.collect do |listing|
      available = true
      listing.booked_dates.each do |date|
        if date_range === date
          available = false
        end
      end
      listing if available == true
    end
  end

  def ratio_reservations_to_listings
    if listings.count > 0
      reservations.count / listings.count
    else
      0
    end
  end


  class_methods do
    def highest_ratio_res_to_listings
        self.all.max {|a, b| a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings}
    end

    def most_res
      self.all.max {|a, b| a.reservations.count <=> b.reservations.count }
    end
  end
end
