class City < ActiveRecord::Base
  extend Combine
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start, finish)
    range = start..finish
    dates = []
    listings.each do |listing| 
      dates << unless listing.reservations.any? do |reservation|
        range.overlaps?(reservation.checkin..reservation.checkout)
        end
      end
    dates
    end
  end
  
end