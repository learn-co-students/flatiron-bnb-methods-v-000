module Reservable
  extend ActiveSupport::Concern

  class_methods do
    def highest_ratio_res_to_listings
      cities = self.all.sort_by {|city| city.reservations.count.to_f / city.listings.count.to_f}
      cities.reverse.first
    end

    def most_res
      cities = self.all.sort_by {|city| city.reservations.count}
      cities.reverse.first
    end
  end

end