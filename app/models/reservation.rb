class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :reservation_check
  validate :reservation_available?
  validate :valid_times?
  
  
  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end

  private

  def reservation_check
    errors.add(:reservation, "You can't make a reservation on your own property") if listing.host_id == guest_id
  end

  def reservation_available?
    if !self.checkin.nil? && !self.checkout.nil?
      if self.listing.reservations.any? do |reservation|
          dates = (reservation.checkin..reservation.checkout) 
          dates === self.checkin || dates === self.checkout
        end
        errors.add(:reservation, "There are no vaccancies available within this time period")
      end
    end
  end

  def valid_times?
    if !self.checkin.nil? && !self.checkout.nil?
      if self.checkout < self.checkin
        errors.add(:checkin, "Invalid time period provided. Check-in must occur before checkout")
      elsif self.checkin == self.checkout
        errors.add(:checkin, "Checkin cannot be the same time as checkout")
      end
    end
  end

end
