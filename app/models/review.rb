class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, class_name: "User"

  validates :description, :rating, :reservation_id, presence: true
  validates :rating, numericality: true
  validate :trip_completed

  private
  def trip_completed
    if (reservation) && (reservation.status == "accepted") && (reservation.checkout > Date.today)
      errors.add(:reservation, "Reservation needs to be accepted and completed before leaving a review.")
    end
  end

end

## Passes both master and solution branch specs
