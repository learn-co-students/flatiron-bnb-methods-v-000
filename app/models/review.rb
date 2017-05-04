class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true
  validates :rating, numericality: true
  validate :review_checks

  private

  def review_checks
    if reservation && ((reservation.status != "accepted") || (reservation.checkout > Date.today))
      errors.add(:reservation, "Reservation needs to be completed and your trip must be completed")
    end
  end
end
