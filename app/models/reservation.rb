class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate do
    guest_cannot_be_host
    listing_available_at_checkin
    listing_available_at_checkout
    checkin_before_checkout
    checkin_and_checkout_cannot_be_equal
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    duration * self.listing.price
  end

  private

  def guest_cannot_be_host
    self.errors.add(:base, "Guest cannot be host.") if self.guest_id == self.listing.host_id
  end

  def listing_available_at_checkin
    if self.checkin && self.listing.reservations.any? { |reservation| self.checkin >= reservation.checkin && self.checkin <= reservation.checkout }
      self.errors.add(:base, "Listing not available at checkin")
    end
  end

  def listing_available_at_checkout
    if self.checkout && self.listing.reservations.any? { |reservation| self.checkout <= reservation.checkout && self.checkout >= reservation.checkin }
      self.errors.add(:base, "Listing not available at checkout")
    end
  end

  def checkin_before_checkout
    self.errors.add(:base, "Checkin must be before checkout") if self.checkin && self.checkout && self.checkin > self.checkout
  end

  def checkin_and_checkout_cannot_be_equal
    self.errors.add(:base, "Checkin must be different than checkout") if self.checkin && self.checkout && self.checkin == self.checkout
  end



end
