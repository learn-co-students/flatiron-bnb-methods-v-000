module ResultableConcern
  module InstanceMethods
    def ratio_res_to_listings
      num_listings = self.listings.count
      num_reservations = self.listings.collect { |l| l.reservations.count }.sum

      num_listings == 0 ? 0 : num_reservations.to_f / num_listings
    end

    def find_openings(start, finish)
      start_time = start.to_date.beginning_of_day
      finish_time = finish.to_date.end_of_day

      openings = self.listings.collect do |listing|
        listing unless listing.reservations.any? do |reservation|
          start_time.between?(reservation.checkin, reservation.checkout) &&
          finish_time.between?(reservation.checkin, reservation.checkout)
        end
      end
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      results = {}

      all.each do |geo_area|
        results[geo_area] = geo_area.ratio_res_to_listings
      end

      results.max_by { |k,v| v }.first
    end

    def most_res
      sum_cities = self.all.each_with_object(Hash.new(0)) { |city, counts| counts[city] += city.listings.collect { |l| l.reservations.count }.sum }
      sum_cities.max_by { |k,v| v }.first
    end
  end
end
