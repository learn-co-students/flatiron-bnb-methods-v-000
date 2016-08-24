module Reservable
  extend ActiveSupport::Concern

  def ratio_res_to_listings
    reservations.count.to_f / listings.count.to_f
  end

  module ClassMethods
    def most_res
      has_listings.max do |a, b|
        a.reservations.count <=> b.reservations.count
      end
    end

    def highest_ratio_res_to_listings
      has_listings.max do |a, b|
        a.ratio_res_to_listings <=> b.ratio_res_to_listings
      end
    end

    def has_listings
      all.select { |city| city.listings.any? }
    end
  end


end
