class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_is_not_host
  validate :dates_available
  validate :checkin_before_checkout

  def guest_is_not_host
    if Listing.find_by(listing_id).host_id == guest_id
      errors.add(:guest_id, "Guest can't be the same as host.")
    end
  end

  def dates_available
    listing.reservations.each do |reservation|
      unavailable = reservation.checkin..reservation.checkout
      if unavailable === checkin || unavailable === checkout
        errors.add(:guest_id, "Dates unavailable.")
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout
      if checkin >= checkout
        errors.add(:guest_id, "Checkin must be before checkout.")
      end
    end
  end

  def duration
    if checkin && checkout
      checkout - checkin
    end
  end

  def total_price
    duration * Listing.find_by(listing_id).price
  end

end
