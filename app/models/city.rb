class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    start_date_parsed = Date.parse(start_date)
    end_date_parsed   = Date.parse(end_date)

    self.listings.collect do |listing|
      listing if listing.reservations.none?{ |reservation| (reservation.checkin <= end_date_parsed) && (reservation.checkout >= start_date_parsed) }
    end
  end
end

