module Reservable
  extend ActiveSupport::Concern

  def ratio_reservations_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    end
  end

  class_methods do
    def highest_ratio_res_to_listings
      all.max do |a,b|
        a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
      end
    end
  end
end
