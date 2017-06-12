class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true
  validates :rating, numericality: true
  validate :review_status

  def review_status
    if reservation && ((reservation.status != "accepted") || (reservation.checkout > Date.today))
      errors.add(:reservation, "Review can't be taken until after checkout")
    end
  end
end
