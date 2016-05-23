class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  include Reservable

  def city_openings(start_date, end_date)
    listings.available_listings_for_dates(start_date, end_date)
  end

end
