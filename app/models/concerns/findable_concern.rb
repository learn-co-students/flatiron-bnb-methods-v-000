module FindableConcern
  module ClassMethods
    def highest_ratio_res_to_listings
      most_popular = ""
      highest_ratio = 0.00

      all.each do |city|
        temp_ratio = city.reservations.count / city.listings.count.to_f
        if temp_ratio > highest_ratio
          highest_ratio = temp_ratio
          most_popular = city
        end
      end
      most_popular
    end

    def most_res
      most_popular = ""
      most_res = 0

      all.each do |city|
        temp_res = city.reservations.count
        if temp_res > most_res
          most_res = temp_res
          most_popular = city
        end
      end
      most_popular
    end
  end

  module InstanceMethods
    def city_openings(start_date, end_date)
      openings(start_date, end_date)
    end

    def neighborhood_openings(start_date, end_date)
      openings(start_date, end_date)
    end

    def openings(start_date, end_date)
      res_dates = [Date.parse(start_date), Date.parse(end_date)]

      all_listings = listings.to_a
      all_listings.delete_if do |listing|
        listing.reservations.any? do |res|
          res_dates.any?{|date| (res.checkin..res.checkout).include?(date)}
        end
      end
    end
  end
end
