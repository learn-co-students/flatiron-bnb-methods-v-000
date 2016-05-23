module Reservable
  extend ActiveSupport::Concern

  included do
    def res_to_listings_ratio
      total_reservations.to_f / listings.count.to_f
    end

    def total_reservations
      listings.reduce(0) { |total, listing| listing.reservations.count + total }
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      has_listings.max { |a,b| a.res_to_listings_ratio <=> b.res_to_listings_ratio }
    end

    def most_res
      has_listings.max { |a,b| a.total_reservations <=> b.total_reservations }
    end

    def has_listings
      all.select { |city| city.listings.any? }
    end
  end
end
