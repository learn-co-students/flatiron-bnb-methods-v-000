class City < ActiveRecord::Base

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(checkin, checkout)
    self.listings.map do |listing|
      listing
    end
  end

  def self.highest_ratio_res_to_listings
    city_with_highest_ratio = ''
    highest_ratio = 0
    self.all.map do |city|
      number_of_reservations = city.listings.map {|listing| listing.reservations}.flatten.count
      city_ratio = number_of_reservations/city.listings.count

      if city_ratio > highest_ratio
        city_with_highest_ratio = city
        highest_ratio = city_ratio
      end
    end
    city_with_highest_ratio
  end

  def self.most_res
    City.all.max_by do |city|
      city.reservations.count
    end
  end


end
