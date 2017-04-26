class Reservation < ActiveRecord::Base
  #validates :duration, numericality: {greater_than: 0, allow_nil: true}

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  # validate :listing_availability
  validate :no_self_reservations
  validate :not_same_day

  def duration
    self.checkout.day - self.checkin.day
  end

  def no_self_reservations
    host = Listing.find(self.listing_id)
    errors.add(:listing, "is not valid") if host.id == self.guest_id
  end

  def total_price
    Listing.find(self.listing_id).price * duration
  end

  # def listing_availability
  #   self.id == nil
  # end

  def not_same_day
    if self.checkout.nil? || self.checkin.nil?
      errors.add(:listing, "is not valid")
    else
      errors.add(:listing, "is not valid") unless self.checkout > self.checkin
    end
  end
end
