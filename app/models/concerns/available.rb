module Available
  extend ActiveSupport::Concern

  module InstanceMethods
    def openings(date1, date2)
      Listing.all.select do |listing|
        listing.reservations.each do |reservation|
          ((reservation.checkin.to_date)..(reservation.checkout.to_date)) == ((date1.to_date)..(date2.to_date))
        end
      end
    end

    def ratio_res_to_listings
      #@objects.max { |a, b| (a.reservations.count.to_f/a.listings.count.to_f) <=> (b.reservations.count/b.listings.count)}

      if listings.count > 0
        reservations.count.to_f / listings.count.to_f
      else
        0
      end
    end
  end

module ClassMethods
    def most_res
      all.max { |a, b| a.reservations.count <=> b.reservations.count }
    end
  end

end
