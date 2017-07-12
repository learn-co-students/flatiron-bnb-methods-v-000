class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :checkin_before_checkout
  validate :not_own
  validate :available?

  def duration
    self.checkout - self.checkin
  end

  def total_price
    duration * listing.price
  end

  def available?
   if self.status != "accepted"
      errors.add(:reservation, "Listing is unavailable at this time.")
    end
  end

  def checked_out?
    if self.checkout > Date.today
      errors.add(:reservation, "You must be checked out to write a review.")
    end
  end

private

  def checkin_before_checkout
    if self.checkin && self.checkout && !(self.checkin < self.checkout)
      self.errors.add(:checkout, "Please make your checkout date after your checkin date.")
    end
  end

  def not_own
    if self.guest_id == listing.host_id
      self.errors.add(:guest, "A host can't be her own guest!")
    end
  end

end
