class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date_start, date_end)
    self.listings.select do |listing|
      !listing.reservations.any? do |reservation|
        (Date.parse(date_start.to_s) - Date.parse(reservation.checkout.to_s)) * (Date.parse(reservation.checkin.to_s) - Date.parse(date_end.to_s)) >= 0
      end
    end
  end
end
