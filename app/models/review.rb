class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :accepted, :checked_out

  private

  def accepted
    if reservation && reservation.status != "accepted"
      errors.add(:reservation, "Reservation must be accepted before leaving a review")
    end
  end

  def checked_out
    if reservation && reservation.checkout > Time.now
      errors.add(:reservation, "You must check out before leaving a review.")
    end
  end

end
