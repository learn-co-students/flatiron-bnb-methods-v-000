class Neighborhood < ActiveRecord::Base
  extend Reserve::ClassMethods
  include Reserve::InstanceMethods
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(in_day, out_day)
    openings(in_day, out_day)
  end
end
