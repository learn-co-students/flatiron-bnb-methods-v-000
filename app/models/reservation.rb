class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :host_guest_different, :available_during_stay, :checkin_before_checkout

  # Duration is calculated by subtracting the checkin date from the checkout date
  def duration
    if checkin && checkout
      duration = checkout - checkin
    end
    duration
  end

  # The total price is calculated by multiplying the listings price per night by the
  # number of nights (duration)
  def total_price
    total_price = 0

    total_price = listing.price * duration
  end

  private

  # Custom validation to ensure that that the host cannot reserve their own home
  def host_guest_different
    if listing.host_id == guest_id
      errors.add(:guest_id, "You cannot reserve your own place.")
    end
  end

  # Custom validation ensures that a listing is available for the requested dates
  def available_during_stay
    if checkin && checkout && !listing.available?(checkin, checkout)
      errors.add(:guest_id, "Unfortunately, this place isn't available for the dates you requested")
    end
  end

  # Custom validation ensures that a checkout date must come after a checkin date
  def checkin_before_checkout
    if checkin && checkout && checkout <= checkin
      errors.add(:guest_id, "You cannot checkout before checking in.")
    end
  end

end
