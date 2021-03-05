module Stats
  extend ActiveSupport::Concern

  module InstanceMethods
    def ratio
      listings.count == 0 ? 0 : reservations.count / listings.count.to_f
    end
  end

  module ClassMethods
    def most_res
      # self.all.max_by {|city| city.reservations.count}
      most_reservation = "currently unknown"
      total_reservation_number = 0
      self.all.each do |place|
        place_reservation_number = place.reservations.count
        if place_reservation_number > total_reservation_number
          total_reservation_number = place_reservation_number
          most_reservation = place
        end
      end
      most_reservation
    end

    def highest_ratio_res_to_listings
      # self.all.max_by {|city| city.ratio}
      popular_place = self.create(name: "There is no popular place")
      highest_ratio = 0.00
      self.all.each do |place|
        popularity_ratio = place.ratio
        if popularity_ratio > highest_ratio
          highest_ratio = popularity_ratio
          popular_place = place
        end
      end
      popular_place
    end

  end

end