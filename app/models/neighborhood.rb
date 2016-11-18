class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  extend Available::ClassMethods
  include Available::InstanceMethods

  def neighborhood_openings(date1, date2)
    openings(date1, date2)
  end

  def self.highest_ratio_res_to_listings
    all.max {|a, b| a.ratio_res_to_listings <=> b.ratio_res_to_listings }
  end
end
