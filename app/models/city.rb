class City < ActiveRecord::Base
  include InstanceMethods
  extend SharedMethods
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start, finish)
    parse_overlap(start, finish)
  end

  def self.highest_ratio_res_to_listings
    city_res_count = 0
    high_ratio = nil
    self.all.each do |city|
      city.listings.each do |listing|
        if city_res_count < listing.reservations.count
          city_res_count = listing.reservations.count
          high_ratio = city
        end
      end
    end
    high_ratio
  end

  def self.most_res
    city_res_count = 0
    most_res = nil
    self.all.each do |city|
      city.listings.each do |listing|
        if city_res_count < listing.reservations.count
          city_res_count = listing.reservations.count
          most_res = city
        end
      end
    end
    most_res
  end

end
