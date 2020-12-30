class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_host
  validate :not_already_reserved
  validate :appropriate_dates

  def not_host
    if self.listing.host == self.guest
      errors.add(:guest, "You cannot make a reservation on your own place.")
    end
  end

  def not_already_reserved
    errors.add(:checkin, "Already booked") if dates_present? && reserved?
  end

  def appropriate_dates
    if dates_present? && self.checkin >= self.checkout
      errors.add(:checkin, "Cannot check in on same day or after checkout")
    end
  end

  def duration
    (self.checkout - self.checkin).to_i if dates_present?
  end

  def total_price
    self.duration * self.listing.price
  end

  def dates_present?
    !!self.checkin && !!self.checkout
  end

  def reserved?
    self.listing.reservations.any? do |r|
      ( (r.checkin...r.checkout).cover?(self.checkin) || (self.checkin...self.checkout).cover?(r.checkin) ) && r.status == 'accepted'
    end
  end

end
