class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, presence: true, numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 5,
              only_integer: true
            }
  validates :reservation, presence: true

  validate :checked_out
  validate :reservation_accepted

  private

  def checked_out
    if reservation && reservation.check_out > Date.today
      errors.add(:reservation, "Reservation must have ended to leave a review.")
    end
  end

  def reservation_accepted
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Reservation must be accepted to leave a review.")
    end
  end

  # belongs_to :reservation
  # belongs_to :guest, :class_name => "User"
  #
  # validates :rating, presence: true
  # validates :description, presence: true
  # validates :reservation_id, presence: true
  # validate :res_passed
  # validate :res_accepted
  #
  #
  # private
  #
  # def res_accepted
  #   errors.add(:review, "reservation must be approved") if reservation && reservation.status && reservation.status != "accepted"
  # end
  #
  # def res_passed
  #   errors.add(:review, "must check out before you can reivew reservation") if reservation && reservation.check_out && reservation.check_out > Date.today
  # end
end
