class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  validate :check_valid_reservation

  private

  def check_valid_reservation
    if Reservation.exists?(self.reservation_id)
      if reservation.status != "accepted" || reservation.checkout > Date.today
        errors.add(:reservation_id, "is invalid")
      end
    else
      errors.add(:reservation_id, "no reservation found!")
    end
  end
end
