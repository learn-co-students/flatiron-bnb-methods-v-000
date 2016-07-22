class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :checked_out?, :reservation_accepted?

  def checked_out?
    if self.reservation && reservation.checkout && reservation.checkin
      errors.add(:guest_id, 'Not checkout yet') unless self.reservation.checkout < Date.today
    end
  end

  def reservation_accepted?
    if self.reservation.try(:status) != 'accepted'
      errors.add(:guest_id, 'Reservation has not been accepted')
    end
  end
end
