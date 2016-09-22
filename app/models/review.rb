class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description, :reservation
  validate :occurred_after_checkout, if: "reservation && created_at"

  def occurred_after_checkout
    if (reservation.checkout >= created_at.to_date)
      errors.add(:reservation, "can't be ongoing at time of review")
    end
  end
end
