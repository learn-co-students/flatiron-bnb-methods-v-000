class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validate :reservation_accepted, :checked_out







  private

  def reservation_accepted
    if reservation.try(:status) != "accepted"
      errors.add(:reservation, "Reservation must be accepted to leave a review.")
    end
  end

  def checked_out
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reservation must have ended to leave a review.")
    end
  end
end
