class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :reservation_has_been_accepted
  validate :checkout_has_happened

  # is invalid without an associated reservation, has been accepted, and checkout has happened
  def reservation_has_been_accepted
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "You must first make a reservation to leave a review.")
    end
  end

  def checkout_has_happened
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "You must first check out to leave a review.")
    end
  end

end
