class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :valid_reservation?

  private

  def valid_reservation?
    if reservation
      if !reservation.checkout.past? || reservation.status != "accepted"
        errors.add(:reservation, "Reservation must be accepted and completed before leaving a review.")
      end
    end
  end

end
