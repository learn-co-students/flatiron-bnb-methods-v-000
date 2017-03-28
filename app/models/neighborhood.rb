class Neighborhood < ActiveRecord::Base

  extend Sortable

  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(start_date, end_date)
    parsed_start = Date.parse(start_date)
    parsed_end = Date.parse(end_date)
    available = []
    listings.each do |listing|
      available << listing unless listing.reservations.any? do |reservation|
        (parsed_start..parsed_end).overlaps?(reservation.checkin..reservation.checkout)     
      end       
    end 
    available
  end
  
end
