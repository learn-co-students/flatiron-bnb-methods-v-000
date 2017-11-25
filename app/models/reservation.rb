class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :not_owner
  validate :is_available
  validate :checkin_before_checkout

  # knows about its duration based on checkin and checkout dates
  def duration
    checkout - checkin
  end

  # knows about its total price
  def total_price
    listing.price * duration
  end

  private

  # validates that you cannot make a reservation on your own listing
  def not_owner
    if guest_id == listing.host_id
       errors.add(:reservation, "You cannot book your own listing.")
    end
  end

  # validates that a listing is available at checkin before making reservation
  # validates that a listing is available at checkout before making reservation
  # validates that a listing is available at for both checkin and checkout before making reservation
  def is_available
    if checkin && checkout
      listing.reservations.each do |reservation|
        if reservation.checkin <= checkout && reservation.checkout >= checkin
         errors.add(:reservation, "Please check your dates and try again.")
       end
      end
    end
  end

  # validates that checkin is before checkout
  # validates that checkin and checkout dates are not the same
  def checkin_before_checkout
    if checkout && checkin && checkout <= checkin
      errors.add(:reservation, "Please check your dates and try again.")
    end
  end

end
