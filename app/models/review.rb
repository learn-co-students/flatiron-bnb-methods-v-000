class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :checked_out
  validate :reservation_accepted

  private

  def checked_out
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Can't leave a review before checking out")
    end
  end

  def reservation_accepted
    if reservation != nil
      if reservation.status != "accepted"
        errors.add(:reservation, "Reservation be accepted")
      end
    end
  end
end
