class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin_day, checkout_day)
    #uses checkin and checkout to determine
    #which listings are not booked/available listings
  end

  def self.highest_ratio_res_to_listings
    #knows the city with the highest ratio of reservations to listings
  end

  def self.most_res
    #knows the city with the most reservations
  end



end

