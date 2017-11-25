class City < ActiveRecord::Base
  extend Area::ClassMethods
  include Area::InstanceMethods
  
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(d1, d2)
    self.openings(d1, d2)
  end

end

