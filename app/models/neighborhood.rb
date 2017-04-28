class Neighborhood < ActiveRecord::Base
  include Stats
  extend Stats
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def self.highest_ratio_res_to_listings
    res_to_listings
  end

  def neighborhood_openings(cin,cout)
    open?(cin,cout)
  end

  def self.most_res
    self.all.sort_by { |n| n.reservations.count }.last
  end

end
