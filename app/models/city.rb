class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include Bnb

  def city_openings(startdate, enddate)
    available(startdate, enddate)
  end
end
