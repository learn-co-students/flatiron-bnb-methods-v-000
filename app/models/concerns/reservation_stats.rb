module ReservationStats
  extend ActiveSupport::Concern

  included do
    def res_to_listings
      reservations.count.to_f / listings.count.to_f
    end
  end


  module ClassMethods
    def highest_ratio_res_to_listings
      with_listings.max do |x, y|
        x.res_to_listings <=> y.res_to_listings
      end
    end

    def most_res
      with_listings.max do |x, y|
        x.reservations.count <=> y.reservations.count
      end
    end

    def with_listings
      all.select{|x| x.listings.any?}
    end

    def highest_listings
      with_listings.collect do |x|
        x.listings.order("listings.reservations_count DESC").limit(1)
      end
    end
  end
end
