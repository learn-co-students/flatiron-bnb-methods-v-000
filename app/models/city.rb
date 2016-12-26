class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(s_date, e_date)

    input = Date.parse(e_date)..Date.parse(s_date)

    open_listings = []

    self.listings.each do |listing|
       if listing.reservations.none? do |reservation|
             range = reservation.checkin..reservation.checkout
             range.overlaps?(input)
          end
          open_listings << listing
        end
      end
      open_listings
  end

end
