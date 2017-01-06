class City < ActiveRecord::Base
  extend SharedClass
  include SharedInstance
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(starting, ending)
    openings(starting, ending)
  end

end
