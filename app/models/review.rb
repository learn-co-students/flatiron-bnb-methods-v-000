class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :presence => true
  validates :description, :presence => true
  validates :reservation, :presence => true
  validate :occurred_after_checkout, if: "reservation && created_at"

  def occurred_after_checkout
    if (reservation.checkout >= created_at.to_date)
      errors.add(:reservation, "reservation must be complete before review")
    end
  end
end