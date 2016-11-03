class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_not_host
  validate :listing_available
  validate :checkin_before_checkout
  validate :checkin_and_checkout_different_days

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

  private

  def guest_not_host
    if listing.host && guest
      if listing.host_id == guest.id
        errors.add(:guest_not_host, "Guest can't be same person as host.")
      end
    end
  end

  def listing_available
    if !listing.available?(checkin, checkout)
      errors.add(:listing_available, "Listing not available for requested dates.")
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin > checkout
      errors.add(:checkin_before_checkout, "Checkout date must be AFTER checkin.")
    end
  end

  def checkin_and_checkout_different_days
    if checkin && checkout && checkin == checkout
      errors.add(:checkin_and_checkout_different_days, "Checkout date must be AFTER checkin.")
    end
  end
end
