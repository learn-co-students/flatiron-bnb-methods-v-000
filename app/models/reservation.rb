class Reservation < ActiveRecord::Base

  include Measurable::InstanceMethods


  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :not_own_listing, :is_available?, :checkin_before_checkout

  # knows about its duration based on checkin and checkout dates
  def duration
    Date.parse(self.checkout.to_s).mjd - Date.parse(self.checkin.to_s).mjd
  end

  # knows about its total price
  def total_price
    self.listing.price * self.duration
  end

  private
  # validates that you cannot make a reservation on your own listing
  def not_own_listing
    if self.guest == self.listing.host
      errors.add(:guest, "You can't reserve your own listing")
    end
  end

  # validates that a listing is available at for both checkin
  # and checkout before making reservation
  def is_available?
    if !self.listing.available?(self.checkin, self.checkout)
      errors.add(:guess, "This listing is not available")
    end
  end

  # validates that checkin is before checkout
  # validates that checkin and checkout dates are not the same
  def checkin_before_checkout
    if self.checkin && self.checkout && self.checkin >= self.checkout
      errors.add(:guest, "Your checkin date must be before your checkout date")
    end
  end

end
