require 'pry'

class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :guest_and_host_are_different?
  validate :reservation_available?
  validate :valid_checkin_and_checkout?

  def guest_and_host_are_different?
    if self.listing.host == self.guest
      errors.add(:host, "You can't make a reservation on your own listing!")
    end
  end

  def reservation_available?
    self.listing.reservations.each do |reservation|
      booked_dates = reservation.checkin..reservation.checkout
      if booked_dates === self.checkin || booked_dates === self.checkout
        errors.add(:base, "The dates you requested are not available.")
      end
    end
  end

  def valid_checkin_and_checkout?
    if self.checkin == self.checkout
      errors.add(:base, "You can't checkin and checkout on the same day.")
    end
    unless !self.checkin || !self.checkout
      if self.checkin >= self.checkout
        errors.add(:base, "You can't checkout before you checkin!")
      end
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    duration * self.listing.price
  end
end
