class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validates_associated :reservation

  validate :reservation_accepted
  validate :trip_is_over

  def trip_is_over
      if reservation && reservation.try(:checkout) > Date.today
      errors.add(:reservation, "review must be posted after checkout")
    end
  end

  def reservation_accepted
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "reservation must be accepted before leaving a review")
    end
  end
end
