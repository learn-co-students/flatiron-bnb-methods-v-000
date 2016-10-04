class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_own_reservation?
  validate :listing_available_at_checkin?
  validate :checkin_before_checkout?
  validate :checkin_is_not_checkout

  def not_own_reservation?
    if self.listing.host_id == self.guest_id
      errors.add(:reservation, "Can not reserve your own listing")
    end
  end

  def listing_available_at_checkin?
    listing.reservations.each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:checkin, "Reservation is not available for this checkin date")
      end
    end
  end

  def checkin_before_checkout?
    if checkin.to_s <= checkout.to_s
    else
      errors.add(:checkout, "Check-in date must be before Check-out date")
    end
  end

  def checkin_is_not_checkout
    if checkin == checkout
      errors.add(:samedates, "Can not check in and out on the same day")
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    self.listing.price.truncate(2) * duration
  end

end
