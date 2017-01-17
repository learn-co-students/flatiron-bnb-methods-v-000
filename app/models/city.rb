class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    listings.includes(:reservations).select do |listing|
      listing.reservations.none? do |reservation|
        reservation.checkin <= end_date && start_date <= reservation.checkout
      end
    end
  end
end

