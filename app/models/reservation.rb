class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :invalid_reservation?
  validate :available?
  validate :checkin?
  validate :reservation_dates

  def invalid_reservation?
  	if self.listing.host == self.guest
      errors.add(:host, "You can't make a reservation on your own listing!")
  	end
  end

  def available?
  	if checkin && checkout
        listing.reservations.each do |reservation|
          if reservation.checkin <= checkout && reservation.checkout >= checkin
            errors.add(:reservation, "Check your dates and try again.")
          end
        end
    end
  end

  def checkin?
    if checkin && checkout && !(self.checkin <= self.checkout)
      errors.add(:reservation, "Please select a date after your checkout date.")
    end
  end

  def reservation_dates
    if self.checkin == self.checkout
      errors.add(:reservations, "Checkin and Checkout dates cannot be on the same day.")
    end
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price.to_i * duration
  end

end
