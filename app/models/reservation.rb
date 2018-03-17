class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :guest_not_host #validate that you cannot make a reservation on your own listing
  validate :check_availability
  validate :checkout_after_checkin

  def duration #date objects: (Fri, 25 Apr 2014)
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.duration * self.listing.price
  end

  private

  def guest_not_host
    if self.listing.host == self.guest
      errors.add(:guest_id, "You cannot make a reservation on your own listing")
    end
  end

  # Check if listing is available for a reservation request
  def check_availability
    self.listing.reservations.each do |reservation|
      booked_dates = reservation.checkin..reservation.checkout
      if booked_dates === self.checkin || booked_dates === self.checkout # === means if fits within set
        errors.add(:guest_id, "Not available during dates")
      end
    end
  end

  # Checks if checkout day happens after checkin day
  def checkout_after_checkin
    if self.checkout && self.checkin
      if self.checkout <= self.checkin
        errors.add(:guest_id, "Checkin has to be after checkout")
      end
    end
  end

end
