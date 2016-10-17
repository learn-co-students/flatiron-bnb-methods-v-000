class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: :true
  validate :invalid_checkin_checkout
  validate :invalid_dates


  #  Validates that checkin is before checkout
  #  Validates that checkin and checkout dates are not the same
  def invalid_checkin_checkout
    if !self.checkin.nil? && !self.checkout.nil?
      if self.checkin >= self.checkout 
        errors.add(:invalid_dates, "Dates are invalid")
      end
    end
  end

  def duration
    checkout - checkin
  end

  # Returns the price using the duration and the price per day of the listing
  # Price is a column in listings table
  def total_price
    listing.price * duration
  end

  # Validates that a listing is available at checkin before making reservation 
  def invalid_dates
    self.listing.reservations.each do |reservation|
      existing_reservations = reservation.checkin..reservation.checkout 
      if existing_reservations.include?(self.checkin) || existing_reservations.include?(self.checkout)
        errors.add(:checkin_taken, "The date is already taken")
      end
    end 
  end

  # Am I missing a validation to check that you cannot make a reservation on your own listing?

end