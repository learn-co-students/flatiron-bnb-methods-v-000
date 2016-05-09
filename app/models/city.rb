class City < ActiveRecord::Base
  include ResultableConcern::InstanceMethods
  extend ResultableConcern::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start, finish)
    find_openings(start, finish)
  end
end
