class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date_start, date_end)

  end

  def self.highest_ratio_res_to_listings

  end

  def self.most_res

  end

end
