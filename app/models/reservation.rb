class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :different_dates?, if: "checkin.present? && checkout.present?"
  validate :checkout_before_checkin?, if: "checkin.present? && checkout.present?"

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

end
