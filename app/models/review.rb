class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :reservation_has_been_accepted
  validate :checkout_has_happened

  def reservation_has_been_accepted
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Reservation must be accepted to leave a review.")
    end
  end

  def checkout_has_happened
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reservation must have ended to leave a review.")
    end
  end
end
