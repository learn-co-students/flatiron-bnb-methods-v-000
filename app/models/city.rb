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
  has_many :reservations, through: :listings

  def self.reservations_of_cities
    City.joins(:reservations).group(:city_id).count
  end

  def self.listings_of_cities
    City.joins(:listings).group(:city_id).count
  end

  def self.most_reservations
    city_id = reservations_of_cities.max_by{|k,v| v}.first
    City.find(city_id)
  end

  def self.reservations_per_listings
    # reservations of cities = {city_id => reservation_count, 15 = 1}
    # listings_of_cities = {city_id = listing_count, 15 = 1}
    ratios = listings_of_cities.each_with_object({}) do |(city_id, number_of_listings), obj|
      obj[city_id] = reservations_of_cities[city_id].to_f / number_of_listings
    end
    # ratios = {nyc_id => 1.5, philly_id => 3.3,  }
    city_id = ratios.max_by{|k,v| v}.first
    City.find(city_id)
  end
end

