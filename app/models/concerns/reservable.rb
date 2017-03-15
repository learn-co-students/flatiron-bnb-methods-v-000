module Reservable
  extend ActiveSupport::Concern

  module InstanceMethods

    def ratio_reservations_to_listings
      if listings.count > 0
        reservations.count.to_f / listings.count.to_f
      end
    end

  end

  module ClassMethods

    def most_res
      all.max {|a, b| a.reservations.count <=> b.reservations.count}
    end

    def highest_ratio_res_to_listings
       all.max do |a, b|
         a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
       end
     end


  end
end
