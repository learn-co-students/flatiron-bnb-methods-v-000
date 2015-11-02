# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def self.most_reservations_per_listing
    ratio = {}
    reservations_hash = self.reservations_for_all_cities
    listings_for_all_cities.each do |city_id, number_of_listings|
      ratio[city_id] = (reservations_hash[city_id] / number_of_listings.to_f)
    end
    
    city_id = ratio.max_by{|k, v| v }.first
    City.find(city_id)
  end

  def total_number_of_reservations
    reservations.count
  end

  def total_number_of_listings
    reservations.map(&:listings).count
  end

  def reservations_per_listings
    total_number_of_reservations / total_number_of_listings 
  end

  def self.most_reservations
    city_id = reservations_for_all_cities.max_by{|k, v| v }.first
    City.find(city_id)
  end

  def self.listings_for_all_cities
    City.joins(:listings).group('city_id').count("listings.id")
  end

  def self.reservations_for_all_cities
    city_id = City.joins(:listings => :reservations).group('city_id').count("reservations.id")
  end
end

