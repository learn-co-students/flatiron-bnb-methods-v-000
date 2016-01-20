class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :not_own_listing
  validate :check_availability
  validate :checkout_dates_valid

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end

  private

  def not_own_listing
    if self.listing.host_id == self.guest_id
      errors.add(:own_listing, 'You cannot book your own listing.')
    end
  end

  def check_availability
    self.listing.reservations.each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === self.checkin || booked_dates === self.checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def checkout_dates_valid
    if self.checkin && self.checkout
      if self.checkout <= self.checkin
        errors.add(:guest_id, 'Checkin date needs to be before checkout date.')
      end
    end
  end
end
