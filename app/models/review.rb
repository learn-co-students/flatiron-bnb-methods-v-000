class Review < ActiveRecord::Base
  validates :rating,:description, :reservation, presence: true
  validate :checkout, :reservation_accepted

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  private

  def checkout
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reservation must have ended.")
    end
  end

  def reservation_accepted
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Revervation must be valid")
    end
  end
end
