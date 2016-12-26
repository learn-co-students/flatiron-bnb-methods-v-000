class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(s_date, e_date)
    s_date = Date.parse(s_date)
    e_date = Date.parse(e_date)

    open_listings = []

    self.listings.map do |listing|
       if listing.reservations.none? do |reservation|
             #binding.pry
             range = reservation.checkin..reservation.checkout
            (range === s_date) || (range === e_date)
          end
          open_listings << listing
        end
      end
      open_listings
  end

end
