class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :host_is_not_guest, :listing_is_available, :checkout_is_after_checkin

  def duration
    (checkout-checkin).numerator
  end

  def total_price
    duration * listing.price
  end

  private

  def host_is_not_guest
    if guest == listing.host
      errors.add(:guest_id, "can't be the host")
    end
  end

  def listing_is_available
    if checkin && checkout && !listing.available?(checkin, checkout, id)
      errors.add(:guest_id, "dates unavailable")
    end
  end

  def checkout_is_after_checkin
    if checkin && checkout && (checkout-checkin).numerator <= 0
      errors.add(:checkout, "must be later than checkin")
    end
  end
end
