class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include ReservationStats

  def city_openings(starting, ending)
    start_date = Date.parse(starting)
    end_date = Date.parse(ending)

    available = []

    Listing.all.each do |listing|
     if listing.reservations.none? {|reservation| (start_date < reservation.checkout) && (end_date > reservation.checkin)}
        available << listing
      end
    end
  available
  end


end
