class Review < ActiveRecord::Base
  validates :rating, :description, presence: true
  validate :reservation_is_accepted, :reservation_is_over

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  def reservation_is_over
    unless reservation && reservation.checkout <= Date.today
      errors.add(:reservation, 'must be over before leaving a review')
    end
  end

  def reservation_is_accepted
    unless reservation && reservation.status == 'accepted'
      errors.add(:reservation, 'cannot be viewed if it\'s not accepted')
    end
  end
end
