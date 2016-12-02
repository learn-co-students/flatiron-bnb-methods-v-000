class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :cannot_reserve_own_listing,  :checkin_checkout_valid, :available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end

  private
  def cannot_reserve_own_listing
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end

  def available
    if checkin && checkout
      blocked = listing.reservations.any? do |r|
        checkin.between?(r.checkin, r.checkout) || checkout.between?(r.checkin, r.checkout)
      end
      if blocked
        errors.add(:guest_id, "Your booking is unavailable for desired timeline.")
      end
    end
  end

  def checkin_checkout_valid
    if checkin && checkout
      if checkin >= checkout
        errors.add(:guest_id, "invalid dates")
      end
    end
  end


end
