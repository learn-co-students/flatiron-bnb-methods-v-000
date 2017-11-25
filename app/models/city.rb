class City < ActiveRecord::Base
  include Helper
  extend Helper::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def self.highest_ratio_res_to_listings
    # method should return the City that is "most full".
    # What that means is it has the highest amount of reservations per listing.
    city_return_value = self.res_to_listings
    return City.find_by(id: city_return_value)
  end

  def city_openings(checkin, checkout)
    openings(checkin, checkout)
  end

  def self.most_res
    city_return_id = self.area_most_res
    return City.find_by(id: city_return_id)
  end
end
