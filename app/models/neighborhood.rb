class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def self.highest_ratio_res_to_listings
  end

  def self.most_res
  end

  def neighborhood_openings(arrival, departure)
  end

end
