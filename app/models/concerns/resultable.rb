require 'pry'
module Resultable
  extend ActiveSupport::Concern

  def openings(start_date, end_date)
    requested_dates = start_date..end_date
    openings = self.listings.select do |listing|
      listing.reservations.all? do |reservation|
        !(requested_dates === reservation.checkin) || !(requested_dates === reservation.checkout)
      end
    end
  end

  def ratio_reservations_to_listings
    if listings.count > 0  
      reservations.count.to_f / listings.count.to_f
    else 
      0.0
    end
  end

  class_methods do 
    def highest_ratio_res_to_listings
      all.max_by {|x| x.ratio_reservations_to_listings}
    end

    def most_res
      all.max do |a, b|
        a.reservations.count <=> b.reservations.count
      end
    end
  end
end