class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true
  validate :reservation_accepted
  validate :checkout_has_happened

  def reservation_accepted
    if Reservation.find_by_id(reservation_id)
      errors.add(:guest_id, "reservation has not been accepted") if Reservation.find_by_id(reservation_id).status != "accepted"
    end
  end

  def checkout_has_happened
    if Reservation.find_by_id(reservation_id)
      errors.add(:guest_id, "checkout has not occurred") if
      Reservation.find_by_id(reservation_id).checkout > DateTime.now.to_date
    end
  end

end
