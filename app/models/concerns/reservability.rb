module Reservability

  module InstanceMethods
    def openings(checkin, checkout)
      self.listings.select do |listing|
        listing.reservations.all? do |res|
          (checkin.to_datetime >= res.checkout) || (checkout.to_datetime <= res.checkin)
        end
      end
    end

    def res_to_list_ratio
      if self.listings.count > 0
        self.reservations.count.to_f / self.listings.count.to_f
      else
        0
      end
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      all.max_by {|city| city.res_to_list_ratio}
    end

    def most_res
      all.max_by {|city| city.reservations.count}
    end
  end

end
