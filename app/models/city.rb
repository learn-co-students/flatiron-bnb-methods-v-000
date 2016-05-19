class City < ActiveRecord::Base
  include Areas::InstanceAreas
  extend Areas::ClassAreas

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin_date, checkout_date)
    openings(checkin_date, checkout_date)
  end

end
