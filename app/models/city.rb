class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :neighborhoods

  extend Available::ClassMethods
  include Available::InstanceMethods

  def city_openings(date1, date2)
    openings(date1, date2)
  end
end
