class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  # Validations
  validates_presence_of :rating, :description, :reservation_id
  validate :valid_reservation

  def valid_reservation
    if self.reservation && self.reservation.status != "accepted"
      errors.add(:reservation, "Reservation have not been accepted")
    end

    if self.reservation && self.reservation.checkout > Date.today
      errors.add(:reservation, "Cannot review this reservation")
    end
  end
end
