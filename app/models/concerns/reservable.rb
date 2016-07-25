class Reservable
  extend ActiveSupport::Concern


  module InstanceMethods

    def openings(arrive, depart)
      available = []

      listings.each do |listing|
        if listing.reservations.empty?
          available << listing
        else listing.reservations.each do |rsvp|
          if rsvp.checkin >= depart.to_datetime || rsvp.checkout <= arrive.to_datetime
            available << rsvp.listing
          end
        end      
        end
      end
    end

    def ratio_res_to_listings
      if listings.size > 0
        reservations.size.to_f / listings.size.to_f
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
      all.max {|a, b| a.reservations.size <=> b.reservations.size}
    end

  end
end