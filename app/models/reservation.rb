class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates_presence_of :checkin, :checkout
  validate :reserve_listing, :available, :dates

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end

  def reserve_listing
    if self.guest_id == self.listing.host_id
      errors.add(:reserve_listing, "Cannot reserve listing.")
    end
  end

  def available
    if !self.checkin.nil? && !self.checkout.nil?
      listing.reservations.each do |reservation|
        booked = (reservation.checkin..reservation.checkout)
        if booked === self.checkin || booked === self.checkout
          errors.add(:available, "The dates are not available for this listing.")
        end
      end
    end
  end

  def dates
    if !self.checkin.nil? && !self.checkout.nil?
      if self.checkin >= self.checkout
        errors.add(:dates, "Please choose different dates.")
      end
    end
  end
end
