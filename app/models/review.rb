class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :valid_reservation?

  private

  def valid_reservation?
    @reservation = Reservation.find_by_id(self.reservation_id)
    if self.reservation != nil
      if !self.reservation.checkout.to_date.past? && @reservation.status == "pending"
        errors.add(:reservation, "Reservation must be accepted and completed before leaving a review.")
      end
    end
  end

end
