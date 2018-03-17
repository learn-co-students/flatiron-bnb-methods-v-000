module Reservable

  module Reservable::InstanceMethods
    def openings(start_date, end_date)
      Listing.all.each do |listing|
        listing.reservations.collect do |res|
          if res.checkin >= end_date.to_date && res.checkout <= start_date.to_date
          end
        end
      end
    end

    def res_to_listings_ratio
      if listings.count > 0
        reservations.count.to_f/listings.count.to_f
      else
        0
      end
    end
  end


  module Reservable::ClassMethods
    def highest_ratio_res_to_listings
      all.max { |a, b| a.res_to_listings_ratio <=> b.res_to_listings_ratio}
    end

    def most_res
      all.max { |a, b| a.reservations.count <=> b.reservations.count }
    end
  end

end
