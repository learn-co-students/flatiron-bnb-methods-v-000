class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validates :reservation, presence: true
  validate :checked_out
  validate :reservation_accepted

  private

  #############_methods_for_validation############

  def checked_out
    if self.reservation && self.reservation.checkout >= DateTime.now
      errors.add(:reservation, "must have ended to leave a review")
    end
  end

  def reservation_accepted
    if self.reservation && self.reservation.status != "accepted"
      errors.add(:reservation, "must be accepted to leave a review")
    end
  end

end
# associated reservation, has been accepted, and checkout has happened
