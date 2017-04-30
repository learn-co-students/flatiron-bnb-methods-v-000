class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include Reservable

  def city_openings(start_date, end_date)
  	get_openings(Date.parse(start_date), Date.parse(end_date))
  end

end

