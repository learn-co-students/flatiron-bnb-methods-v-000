class City < ActiveRecord::Base
  include Stats
  extend Stats

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(cin,cout)
    open?(cin,cout)
  end

  def self.highest_ratio_res_to_listings
    res_to_listings
  end

  def self.most_res
    self.all.sort_by { |n| n.reservations.count }.last
  end

end
