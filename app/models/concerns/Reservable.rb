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

    def has_listings
      all.select { |city| city.listings.any? }
    end

    def most_res
      
      locations = {}
      self.all.collect do |location|
        locations[location.name] = location.listings.collect {|listing|listing.reservations.count}.inject {|sum, count| sum + count }
      end
      binding.pry
      most_res_location_name = locations.key(locations.values.compact.max)
      self.find_by(name: most_res_location_name)
    end

  end
end