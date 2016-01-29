module SearchConcerns
  
  module InstanceMethods
    def openings(start_range,end_range)
      checkin_date = Date.parse(start_range)
      checkout_date = Date.parse(end_range)
      listings.select do |listing|
        listing.reservations.all? do |reservation|
          !(reservation.checkin..reservation.checkout).include?(checkin_date) ||
          !(reservation.checkin..reservation.checkout).include?(checkout_date)
        end
      end
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      max_value = 0
      target_obj = nil
      self.all.each do |obj|

        @reservation_count = 0
        obj.listings.each {|listing| @reservation_count += listing.reservations.count}

        next if obj.listings.count == 0
        
        if @reservation_count/obj.listings.count > max_value
          target_obj = obj
          max_value = @reservation_count / obj.listings.count
        end

      end
      target_obj
    end

    def most_res
      target_obj = nil
      max_value = 0
      self.all.each do |obj|
        reservation_count = 0
        obj.listings.each {|listing| reservation_count += listing.reservations.count}

        if reservation_count > max_value
          target_obj = obj
          max_value = reservation_count
        end
      end
      target_obj
    end
  end
end
