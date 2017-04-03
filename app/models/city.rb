class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :neighborhoods

  extend Reservable::ClassMethods
  include Reservable::InstanceMethods

  def city_openings(checkin, checkout)
    openings(checkin, checkout)
  end

end

## Passes master branch
