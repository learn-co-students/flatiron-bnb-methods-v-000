class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates_presence_of :checkin,:checkout
  validate :not_my_own
  validate :available_for_booking
  validate :checkin_before_checkout
  
  def not_my_own
    if self.guest_id == self.listing.host_id
      errors.add(:not_my_own, "Can't stay at your own listing!")
    end
  end
  
  def available_for_booking
    self.listing.reservations.each do |reservation|
      if self.checkin && self.checkout
        if self.checkin.between?(reservation.checkin,reservation.checkout) || self.checkout.between?(reservation.checkin,reservation.checkout)
          errors.add(:available_for_booking, "This date is not available at this property")
        end
      end
    end
  end
  
  def checkin_before_checkout
    if self.checkin && self.checkout 
      if self.checkout <= self.checkin 
        errors.add(:checkin_before_checkout, "checkin must be before checkout")
      end
    end
  end
  
  def duration
    self.checkout-self.checkin
  end
  
  def total_price
    self.duration.to_i * self.listing.price.to_i
  end

end
