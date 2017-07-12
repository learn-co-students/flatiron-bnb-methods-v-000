class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true

  validate :checked_out, :accepted

  private

  # Validates that a guest has checked out before reviewing a stay
  def checked_out
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation,  "Stay must have ended before you can leave a review.")
    end
  end

  # Validates that a guest's reservation was accpeted before reviewing a stay
  def accepted
    if reservation && reservation.status != "accepted"
      errors.add(:reservation, "Reservation must be accepted before leaving a review.")
    end
  end
end
