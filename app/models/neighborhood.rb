class Neighborhood < ActiveRecord::Base
  extend Area::ClassMethods
  include Area::InstanceMethods

  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(d1, d2)
    self.openings(d1, d2)
  end

end
