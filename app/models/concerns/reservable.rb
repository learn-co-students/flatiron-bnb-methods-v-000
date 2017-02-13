module Reservable
   extend ActiveSupport::Concern

  def openings(start_date, end_date)
    listings.merge(Listing.available(start_date, end_date))
  end

  def ratio_res_to_listings
    num_listings = self.listings.count
      num_reservations = self.listings.collect { |l| l.reservations.count }.sum

      num_listings == 0 ? 0 : num_reservations.to_f / num_listings
  end

  class_methods do

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
