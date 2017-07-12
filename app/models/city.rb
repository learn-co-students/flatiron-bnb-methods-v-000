class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include CommonTasks::InstanceMethods
  extend CommonTasks::ClassMethods

  def city_openings(date_1, date_2)
    openings(date_1, date_2)
  end
end
