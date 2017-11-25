class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :description, presence: true
  validates :rating, presence: true
  validate :reservation_happened

  private

  def reservation_happened
    if !self.reservation || self.reservation.status == "pending" || self.reservation.checkout > Date.today
      errors.add(:reservation, "had to have happened before writing a review")
    end
  end

end
