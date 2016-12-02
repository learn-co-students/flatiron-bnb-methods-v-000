class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  include Reservable

  def city_openings(startDate, endDate)
  	openings(startDate, endDate)
  end

end

