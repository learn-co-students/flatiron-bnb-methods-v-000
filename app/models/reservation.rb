class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkout, presence: true
  validates :checkin, presence: true
  validate :cannot_reserve_own_listing
  validate :confirm_availability
  validate :valid_checkin_time

  def duration
    self.checkout - self.checkin
  end

  def total_price
    duration * self.listing.price
  end

  private 

  def cannot_reserve_own_listing
    if self.listing.host_id == self.guest_id
      errors.add(:your_listing, "You cannot reserve your own listing.")
    end
  end  

  def confirm_availability
    if !self.checkin.nil? && !self.checkout.nil?
      
      listing.reservations.each do |reservation|
        reserved = (reservation.checkin..reservation.checkout)
        if reserved === self.checkin || reserved === self.checkout
          errors.add(:unavailable, "Sorry, those dates are already reserved!")
        end
      end
    end
  end

  def valid_checkin_time
    if self.checkin && self.checkout
      if self.checkin >= self.checkout
        errors.add(:date_error, "Your checkout time can't precede the checkin time.")
      end
    end  
  end
end
