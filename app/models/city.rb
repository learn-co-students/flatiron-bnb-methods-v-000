class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    openings_array = self.listings.map do |listing|
      current = nil
      if listing.openings(start_date.to_time, end_date.to_time)
        current = listing 
      end
      current
    end
    openings_array.compact
  end

  def self.highest_ratio_res_to_listings
    city_ratio_array = City.all.map do |city| 
      listings_count = city.listings.count
      reservations_count =  city.listings.map {|listing| listing.reservations.count}.reduce(:+)
      hash = {}
      hash[:reservation_ratio] = reservations_count.to_f / listings_count.to_f
      hash[:city] = city
      hash
    end
    city_ratio_array.max_by{|f| f[:reservation_ratio]}[:city]
  end

  def self.most_res
    city_reservations_array = City.all.map do |city|
      hash = {}
      hash[:reservations_count] = city.listings.map {|listing| listing.reservations.count}.reduce(:+)
      hash[:city] = city 
      hash
    end
    city_reservations_array.max_by{|f| f[:reservations_count]}[:city]
  end
end

