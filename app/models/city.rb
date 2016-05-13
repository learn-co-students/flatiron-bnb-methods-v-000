class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    listings.where(start_date, end_date)
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = self.all.map do |city|
      city.find_ratio_res_to_listings
    end.max
    self.all.select {|city| city.find_ratio_res_to_listings == highest_ratio}.first
  end

  def find_ratio_res_to_listings
    total_res = self.listings.map do |listing|
      listing.reservations.count
    end.sum
    if self.listings.count != 0
      ratio = total_res / self.listings.count
    else
      ratio = 0
    end
  end

  def self.most_res
    most_res = self.all.map {|city| city.city_reservations}.sort.last
    self.all.select {|city| city.city_reservations == most_res}.first
  end

  def city_reservations
    number = self.neighborhoods.map do |n|
      n.listings.map do |l|
        l.reservations.count
      end
    end.flatten.sum
    number
  end
end