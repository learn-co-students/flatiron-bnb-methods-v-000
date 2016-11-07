class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :reservation_complete?

  def reservation_complete?
    if !(reservation && reservation.status == "accepted" && reservation.checkout < Date.today)
      errors.add(:reservation, "Review must be about a real reservation!")
    end
  end

end
