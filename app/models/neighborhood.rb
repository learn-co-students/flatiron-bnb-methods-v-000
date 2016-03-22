class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def self.highest_ratio_res_to_listings
    highest_ratio = self.all.map do |city|
      city.find_ratio_res_to_listings
    end.max
    self.all.select {|city| city.find_ratio_res_to_listings == highest_ratio}.first
  end

  def self.most_res
    most_res = self.all.map {|neighborhood| neighborhood.neighborhood_reservations}.sort.last
    self.all.select {|neighborhood| neighborhood.neighborhood_reservations == most_res}.first
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

  def neighborhood_reservations
    number = self.listings.map do |l|
      l.reservations.count
    end.flatten.sum
    number
  end

  def neighborhood_openings(checkin, checkout)
    self.listings.map do |listing|
      listing
    end
  end
end