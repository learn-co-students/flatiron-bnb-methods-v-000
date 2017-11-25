class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates_presence_of :checkin, :checkout
  validate :reservation_by_host
  validate :reservation_available, :if => "!checkin.nil? && !checkout.nil?"
  validate :checkin_not_equal_checkout, :if => "!checkin.nil? && !checkout.nil?"
  validate :checkout_greaterthan_checkin, :if => "!checkin.nil? && !checkout.nil?"

  def reservation_by_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "Guest and host cannot be the same.")
    end
  end

  def reservation_available
    r = Reservation.where(listing_id: self.listing_id).where.not(id: self.id).collect do |res|
      if (self.checkin.between?(res.checkin, res.checkout)) || (self.checkout.between?(res.checkin, res.checkout))
        errors.add(:reservation, "not available for checkin/checkout on those dates")
      end
    end
  end

  def checkin_not_equal_checkout
    if checkin == checkout
      errors.add(:reservation, "Checkin and Checkout dates cannot be the same.")
    end
  end

  def checkout_greaterthan_checkin
    if checkin > checkout
      errors.add(:reservation, "Checkin date cannot be greater than checkout date.")
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end


end
