class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    Listing.all
  end

  def self.highest_ratio_res_to_listings

    listing_cities = []
    Listing.all.each do |listing| 
      listing_cities << listing.neighborhood.city.name
    end
    
    uniq_cities = listing_cities.uniq  

    full_cities = []
    Reservation.all.each do |reservation|
      if reservation.status == "accepted"
        full_cities << reservation.listing.neighborhood.city.name
      end
    end

    city_hash = {}
    uniq_cities.each do |city|
      city_hash.merge!(city => full_cities.select { |entry| entry == city }.count)
    end

    answer = city_hash.sort_by {|city,num| num}.reverse.to_h.keys.first
    City.find_by_name(answer)

  end

  def self.most_res

    full_cities = []
    Reservation.all.each do |reservation|
      if reservation.status == "accepted"
        full_cities << reservation.listing.neighborhood.city.name
      end
    end

    uniq_cities = full_cities.uniq

    city_hash = {}
    uniq_cities.each do |city|
      city_hash.merge!(city => full_cities.select { |entry| entry == city}.count)
    end

    answer = city_hash.sort_by {|city,num| num}.reverse.to_h.keys.first
    City.find_by_name(answer)

  end

end

