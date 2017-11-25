class Reservation < ActiveRecord::Base
  # Associations
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  # Validations
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :user_check
  validate :check_availability
  validate :checkin_before_checkout?

  # Custom Validation methods
  def user_check
    if self.listing.host == self.guest
      errors.add(:user_check, "Listing Host and Reservation Guest can't be the same person.")
    end
  end

  def check_availability
    if self.checkin && self.checkout
      listing = self.listing
      listing.reservations.each do |reservation|
        if reservation != self
          if self.checkin.between?(reservation.checkin, reservation.checkout)
            errors.add(:check_availability, "Listing is not available at this checkin time.")
          elsif self.checkout.between?(reservation.checkin, reservation.checkout)
            errors.add(:check_availability, "Listing is not available at this checkout time.")
          end
        end
      end
    end
  end

  def checkin_before_checkout?
    if !self.checkin.nil? && !self.checkout.nil?
      if self.checkin >= self.checkout
        errors.add(:checkin_before_checkout, "Invalid checkin or checkout time.")
      end
    end
  end

  # Instance Methods
  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * duration
  end

end
