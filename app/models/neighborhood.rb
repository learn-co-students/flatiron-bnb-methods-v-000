class Neighborhood < ActiveRecord::Base
  include Helper
  extend Helper::ClassMethods

  # Associations
  belongs_to :city
  has_many :listings


  def neighborhood_openings(checkin, checkout)
    openings(checkin, checkout)
  end

  def self.highest_ratio_res_to_listings
    neighborhood_return_value = self.res_to_listings
    return Neighborhood.find_by(id: neighborhood_return_value)
  end

  def self.most_res
    neighborhood_return_id = self.area_most_res
    return Neighborhood.find_by(id: neighborhood_return_id)
  end
end
