class City < ActiveRecord::Base
  include Shareable::InstanceMethods
  extend Shareable::ClassMethods

  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(checkin, checkout)
    overlap(checkin, checkout)
  end
end
