class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_is_not_host
  validate :listing_available?
  validate :checkin_precedes_checkout

  def guest_is_not_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest_is_host, "You cannot make a reservation on your own listing")
    end
  end

  def listing_available?
    if self.status != "accepted"
      errors.add(:listing_not_available, "reservations can only be made for available listings")
    end
  end

  def checkin_precedes_checkout
    if self.checkin && self.checkout && self.checkin != self.checkout
      self.checkin < self.checkout
    else
      errors.add(:checkin_does_not_precede_checkout, "checkin must precede checkout")
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    (self.duration)*(self.listing.price)
  end

end
