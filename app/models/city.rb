class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin_date, checkout_date)
    available_reservations = []

    Reservation.all.each do |reservation|
      if reservation.checkin > checkin_date && reservation.checkout < checkout_date
        available_reservations << reservation
      end
    end
    available_reservations
  end

end

