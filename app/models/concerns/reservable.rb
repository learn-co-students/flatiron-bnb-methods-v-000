module Reservable
  extend ActiveSupport::Concern

  module InstanceMethods
    def openings(start_date, end_date)
      checkin_date, checkout_date = (Date.parse start_date), (Date.parse end_date)
      self.listings.each do |listing|
        listing.reservations.each do |r|
          checkin_date <= r.checkout && checkout_date >= r.checkin
        end
      end
    end

    def ratio_res_to_listings
      if self.listings.size > 0
        self.reservations.size / self.listings.size
      else
        0
      end
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      all.max do |a, b|
        a.ratio_res_to_listings <=> b.ratio_res_to_listings
      end
    end

    def most_res
      all.max{|a, b| a.reservations.size <=> b.reservations.size}
    end
  end
end
