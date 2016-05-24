class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  include Reservable

  def neighborhood_openings(start_date, end_date)
    listings.available_listings_for_dates(start_date, end_date)
  end   
end
