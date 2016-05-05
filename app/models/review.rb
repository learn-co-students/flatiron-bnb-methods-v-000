class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :completed_booking

  def completed_booking
    unless !!self.reservation && self.reservation.status == "accepted" && self.reservation.checkout.past?
      errors.add(:description, "You were not here.")
    end
  end

end
