class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :cannot_reserve_own_listing
  validate :checkin_before_checkout
  validate :check_availability

  def cannot_reserve_own_listing
    if guest_id == listing.host_id
      errors.add(:guest_id, "Cannot reserve your own listing")
    end
  end

  def check_availability
    if listing.reservations.where("checkin < ? AND checkout > ? AND id != ?", checkout, checkin, id || 0).any?
      errors.add(:guest, "Those dates aren't available")
    end
  end

  def checkin_before_checkout
    if checkin && checkout
      if checkin >= checkout
        errors.add(:checkin, "Checkin date must be before checkout date")
      end
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    listing.price * duration
  end

end
