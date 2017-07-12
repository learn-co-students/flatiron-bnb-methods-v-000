class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :own_listing?, :available?, :checkin_not_equal_checkout, :checkin_before_checkout?

  def total_price
    self.listing.price * self.duration
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  private

  def own_listing?
    if self.guest_id == self.listing_id
      errors.add(:listing, "You can't make a reservation on your own listing!")
    end
  end

  def available?
    self.listing.reservations.each do |reservation|
      booked_dates = reservation.checkin..reservation.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def checkin_not_equal_checkout
    if self.checkin == self.checkout
      errors.add(:checkout, "Checkin and Checkout can't be the same!")
    end
  end

  def checkin_before_checkout?
    if !self.checkin.nil? && !self.checkout.nil? && self.checkin > self.checkout
      errors.add(:checkin, "Checkin can't be before checkout!")
    end
  end

end
