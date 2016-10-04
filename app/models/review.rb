class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :associated_reservation

  def associated_reservation
    unless self.reservation != nil && self.reservation.status == "accepted" && self.reservation.checkout <= Date.today
      errors.add(:review, "Requirements have not been met to leave a review")
    end
  end
end
