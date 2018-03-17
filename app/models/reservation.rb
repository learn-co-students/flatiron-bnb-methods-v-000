class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :not_owner, :available, :checkin_before_checkout, if: "checkin? && checkout?"
  validate :dates_different

  def not_owner
    if guest_id == listing.host_id
      errors.add(:guest_id, "You cannot make a reservation on your own listing.")
    end
  end

  def available
    available = listing.reservations.all? do |reservation|
      reservation.checkin > checkout || reservation.checkout < checkin
    end
    if !available
      errors.add(:listing, "Listing is not available.")
    end
  end

  def checkin_before_checkout
    if !(checkin < checkout)
      errors.add(:checkin, "Date checking in must be before checkout.")
      errors.add(:checkout, "Date checking out must be after checkin.")
    end
  end

  def dates_different
    if self.checkin && self.checkout
      if (self.checkin == self.checkout) || (self.checkin > self.checkout)
        errors.add(:reservation, "Checkin and checkout dates must be different.")
      end
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * self.duration
  end
end
