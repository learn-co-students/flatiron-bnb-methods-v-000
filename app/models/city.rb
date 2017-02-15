require 'pry'

class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

    def city_openings(start_date, end_date)
      available_listings = []
      unavailable_listings = []

      Reservation.all.each do |reservation|
              unavailable_listings << reservation.listing if reservation.listing.neighborhood.city == self && overlaps?(start_date, end_date, reservation)
      end

      Listing.all.each do |listing|
          available_listings << listing unless unavailable_listings.include? listing
        end
      available_listings
    end

   def overlaps?(start_date, end_date, other)
      # (start_date - other.checkout) * (other.checkin - end_date) >= 0
      (DateTime.parse(start_date).to_date - other.checkout) * (other.checkin - DateTime.parse(end_date).to_date) >= 0
   end

   def self.highest_ratio_res_to_listings
      listing_count = {}
      ratios = {}
      cities = self.reservation_count

      City.all.each do |city|
        listing_count[city] = 0
          city.listings.each do |listing|
            listing_count[city] += 1
          end #listing
          ratios[city] = cities[city] / listing_count[city]
      end #city
      ratios.max_by{|k,v| v}[0]
   end

   def self.most_res
      city_count = []
      Reservation.all.each do |reservation|
        city_count << reservation.listing.neighborhood.city
      end
      freq = city_count.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
      city_count.max_by { |v| freq[v] }
   end

   def self.reservation_count
      city_count = []
      Reservation.all.each do |reservation|
        city_count << reservation.listing.neighborhood.city
      end
      freq = city_count.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
   end

end

