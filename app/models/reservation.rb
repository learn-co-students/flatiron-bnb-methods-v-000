class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  before_create :check_available
  before_create :check_if_own
  before_create :checkin_before_checkout?

  def duration
    self.checkout - self.checkin
  end

  def total_price
    duration * self.listing.price
  end

  private

  def check_available
    self.listing.available?(self.checkin, self.checkout)
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

end
