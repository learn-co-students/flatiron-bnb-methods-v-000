class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :must_not_reserve_own_listing
  validate :listing_available_before_making_reservation
  validate :checkin_is_before_checkout
  validate :checkin_and_checkout_dates_not_same

  def must_not_reserve_own_listing
    if self.listing.host == self.guest
      errors.add(:listing, "must not reserve your own listing")
    end
  end

  def listing_available_before_making_reservation
    self.listing.reservations.reload.each do |reservation|
      if reservation != self && self.checkin && self.checkout
        if (self.checkin <= reservation.checkout && self.checkout >= reservation.checkin)
          errors.add(:listing, "must be available at check in before making reservation.")
        end
      end
    end
  end

  def checkin_is_before_checkout
    if self.checkin && self.checkout
      if self.checkin > self.checkout
        errors.add(:checkin, "must be before checkout.")
      end
    end
  end

  def checkin_and_checkout_dates_not_same
    if self.checkin && self.checkout
      if self.checkin == self.checkout
        errors.add(:checkin, "and checkout dates are not the same.")
      end
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

end
