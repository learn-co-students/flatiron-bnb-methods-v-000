class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include Available::InstanceMethods
  extend Available::ClassMethods

  def city_openings(first_date, last_date)
    openings(first_date, last_date)
  end
end

