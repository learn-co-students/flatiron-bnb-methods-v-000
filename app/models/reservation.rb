class Reservation < ActiveRecord::Base

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validate :listing_availability
  validate :no_self_reservations
  validate :not_same_day

  def duration
    checkout.day - checkin.day
  end

  def no_self_reservations     # host = Listing.find(self.listing_id)
    errors.add(:listing, "is not valid") if self.listing_id == self.guest_id
  end

  def total_price
    listing.price * duration
  end

  def listing_availability
    errors.add(:listing, "is not valid") unless self.status == "accepted"
  end

  def not_same_day
    if checkout.nil? || checkin.nil?
      errors.add(:listing, "is not valid")
    else
      errors.add(:listing, "is not valid") unless checkout > checkin
    end
  end
end
