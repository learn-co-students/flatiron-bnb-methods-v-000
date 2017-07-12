class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  include Available

  def city_openings(checkin, checkout)
    openings(checkin, checkout)
  end

end
