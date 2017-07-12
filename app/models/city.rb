class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  include Reservability::InstanceMethods
  extend Reservability::ClassMethods

  def city_openings(checkin, checkout)
    openings(checkin, checkout)
  end
end
