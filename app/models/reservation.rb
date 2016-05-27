class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :different_dates?, if: "checkin.present? && checkout.present?"
  validate :checkout_before_checkin?, if: "checkin.present? && checkout.present?"
  validate :host_different_from_guest?
  validate :listing_available?, if: "checkin.present? && checkout.present?"

  def duration
    (self.checkin...self.checkout).to_a.length
  end

  def total_price
    (self.listing.price)*(self.duration)
  end

  def different_dates?
     if self.checkin == self.checkout
      errors.add(:reservation, "Checkin and checkout must be different days.")
    end
  end

   def checkout_before_checkin?
    if checkin > checkout
      errors.add(:reservation, "Checkin date cannot be greater than checkout date.")
    end
  end

  def host_different_from_guest?
    if self.guest_id == self.listing.host_id
      errors.add(:reservation, "You cannot make a reservation on your own listing.")
    end
  end

  def listing_available?
    self.listing.reservations.each do |r|
      dates = (r.checkin..r.checkout).to_a
      if (dates.include?(self.checkin) || dates.include?(self.checkout))
        errors.add(:reservation, "These dates are not available.")
      end
    end
  end

end
