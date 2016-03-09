class Neighborhood < ActiveRecord::Base
  extend Combine
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start, finish)
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