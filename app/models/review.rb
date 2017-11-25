class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validate :has_checked_out?, :reservation_accepted

  # checkout has happened
  def has_checked_out?
    if self.reservation && !self.reservation.checkout.past?
      errors.add(:guest, "You can only leave a review after your reservation has ended")
    end
  end

  # has been accepted
  def reservation_accepted
    if self.reservation && self.reservation.status == "accepted"
    else
      errors.add(:guest, "Reservation must be accepted")
    end
  end

end
