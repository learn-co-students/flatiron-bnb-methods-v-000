class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true, uniqueness: true
  validate :host_cannot_be_guest, :checkin_is_before_checkout

  def duration
    (self.checkout-self.checkin).to_i
  end

  def total_price
    self.duration*self.listing.price
  end

  private

  def host_cannot_be_guest
    if self.guest_id == self.listing_id
      errors.add(:guest_id, "You may not reserve your own place")
    end
  end

  def checkin_is_before_checkout
    if (self.checkout && self.checkin) && (self.checkout < self.checkin)
      errors.add(:guest_id, "You may not select Check Out date prior to Check In date")
    end
  end

end
