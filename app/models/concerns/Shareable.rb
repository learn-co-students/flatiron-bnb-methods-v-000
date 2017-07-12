module Shareable
  extend ActiveSupport::Concern

  module InstanceMethods
    def overlap(first_date, second_date)
     listings.select do |listing|
       listing.reservations.none? do |reservation|
         (Date.parse(first_date) <= reservation.checkout) && (Date.parse(second_date) >= reservation.checkin)
       end
     end
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      all.max_by { |c| c.listings.count.zero? ? 0 : c.reservations.count / c.listings.count }
    end

    def most_res
      all.max_by { |c| c.reservations.count }
    end
  end
end