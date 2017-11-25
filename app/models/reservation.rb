class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :own_listing
  validate :available
  validate :checkin_before_checkout
  validate :checkin_not_checkout

  def own_listing
    if self.guest == self.listing.host
      errors.add(:own_listing, "can't reserve your own listing")
    end
  end

  def available
=begin
    if self.listing.reservations.empty?

    elsif self.checkin == nil || self.checkout == nil
      errors.add(:available, "need checkin/checkout date")
=end
    #checking if true
    if self.checkin && self.checkout
      self.listing.reservations.each do |reservation|
        if (self.checkin >= reservation.checkin && self.checkin <= reservation.checkout) || (self.checkout >= reservation.checkin && self.checkout <= reservation.checkout)
          errors.add(:available, "reservation not available")
        end
      end
    end
  end

  def checkin_before_checkout
    if self.checkin && self.checkout && self.checkin > self.checkout
      errors.add(:checkin_before_checkout, "checkin must be before checkout")
    end
  end

  def checkin_not_checkout
    if self.checkin && self.checkout && self.checkout == self.checkin
      errors.add(:checkin_not_checkout, "checkin and checkout cannot be the same")
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * self.duration
  end

end
