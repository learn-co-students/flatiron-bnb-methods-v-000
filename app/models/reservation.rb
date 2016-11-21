class Reservation < ActiveRecord::Base

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :not_same_user?, :is_available?, :checkout_after_checkin?

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  private

  def not_same_user?
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "Guest and Host cannot be the same.")
    end
  end

  def is_available?
    if self.checkin && self.checkout
      if self.listing.reservations.find {|existing_reservation| (self.checkin <= existing_reservation.checkout) || (self.checkout >= existing_reservation.checkin)}
        errors.add(:checkout, "Cannot overlap with an existing reservation.")
      end
    end
  end

  def checkout_after_checkin?
    if self.checkin && self.checkout
      if self.checkin > self.checkout
        errors.add(:guest_id, "Checkout date must be after checkin date.")
      end
    end
  end

end
