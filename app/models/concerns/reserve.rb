
module Reserve
extend ActiveSupport::Concern

  module InstanceMethods
    def openings(in_day, out_day)
      listings.reject do |listing|
        listing.reservations.detect { |reservation| reservation.unavailable?(in_day.to_date, out_day.to_date) }
      end
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      hash = {}
      all.each {|obj| hash[obj] = obj.reservations.size.to_f / obj.listings.size.to_f if obj.listings.size > 0 }
      hash.key(hash.values.max)
    end

    def most_res
      hash = {}
      all.each {|obj| hash[obj] = obj.reservations.size }
      hash.key(hash.values.max)
    end
  end

end
