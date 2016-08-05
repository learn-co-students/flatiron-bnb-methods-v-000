class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :checkin_is_before_checkout
  validate :host_cannot_be_guest
  validate :dates_available


  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  def checkin_is_before_checkout
    if checkout && checkin && checkout <= checkin
      errors.add(:guest_id, "Your checkout date must be after your checkin date.")
    end
  end

  def host_cannot_be_guest
    if listing.host_id == guest_id
      errors.add(:guest_id, "You cannot book your own listing.")
    end
  end

  def dates_available
    if self.checkin && self.checkout && self.listing.reservations.any?{|r|(r.checkin - self.checkout) * (self.checkin - r.checkout) >= 0}
      errors.add(:guest_id, "Sorry, your dates are not available.")
    end
  end
end

