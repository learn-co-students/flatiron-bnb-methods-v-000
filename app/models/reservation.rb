class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates_presence_of :checkin, :checkout
  validate :guest_and_host_must_be_distinct_users
  validate :listing_is_available, :checkin_is_before_checkout, if: "checkin? && checkout?"

  def guest_and_host_must_be_distinct_users
    if guest == listing.host
      errors.add(:guest, "can't be the same user as host")
    end
  end

  def listing_is_available
    available = listing.reservations.all? do |reservation|
      reservation.checkin > checkout || reservation.checkout < checkin
    end
    if !available
      errors.add(:listing, "can't be occupied at all between checkin and checkout")
    end
  end

  def checkin_is_before_checkout
    if !(checkin < checkout)
      errors.add(:checkin, "can't be after checkout")
      errors.add(:checkout, "can't be before checkin")
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price
  end
end
