class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
  end

  def self.highest_ratio_res_to_listings
  end

  def self.most_res
  end

end
