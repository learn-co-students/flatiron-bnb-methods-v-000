class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  include Available::InstanceMethods
  extend  Available::ClassMethods

  def city_openings(start_date, end_date)
    openings(start_date, end_date)
  end
end
