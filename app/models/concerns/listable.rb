module Listable
  extend ActiveSupport::Concern

  def openings(start_date_string, end_date_string)
    start_date = Date.parse(start_date_string)
    end_date = Date.parse(end_date_string)
    Listing.all.find_all do |listing|
      listing.reservations.all? do |reservation|
        reservation.checkin >= end_date || reservation.checkout <= start_date
      end
    end
  end

  def numberOfReservations
    listings.inject(0) do |sum, listing|
      sum + listing.reservations.size
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      self.all.max_by do |area|
        area.listings.size != 0 ? area.numberOfReservations.to_f / area.listings.size : 0
      end
    end

    def most_res
      self.all.max_by do |area|
        area.numberOfReservations
      end
    end
  end
end