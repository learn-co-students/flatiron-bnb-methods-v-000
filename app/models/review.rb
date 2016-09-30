class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :checked_out
  validate :reservation_accepted

  def checked_out
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "reservation must be ended")
    end
  end

  def reservation_accepted
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "reservation must be accepted")
    end
  end
end
