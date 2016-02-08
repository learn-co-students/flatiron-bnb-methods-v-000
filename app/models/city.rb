class City < ActiveRecord::Base

  extend Sortable 

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
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

