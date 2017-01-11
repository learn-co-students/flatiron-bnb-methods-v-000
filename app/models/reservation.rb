class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :check_if_own
  validate :checkin_before_checkout?
  validate :same_day
  validate :check_available

  def duration
    self.checkout - self.checkin
  end

  def total_price
    duration * self.listing.price
  end

  def check_available
    if self.checkin == nil || self.checkout == nil
      false
    else
      self.listing.available?(self.checkin, self.checkout)
    end
  end

  def check_if_own
    if self.listing.host == self.guest
      errors.add(:guest, "Guest can't be host!")
    end
  end

  def checkin_before_checkout?
    if self.checkin > self.checkout
      errors.add(:checkin, "Checkin can't be before Checkout!")
    end
  end

  def same_day
    if self.checkin == self.checkout
      errors.add(:checkin, "Checkin can't be the same as Checkout!")
    end
  end

end
