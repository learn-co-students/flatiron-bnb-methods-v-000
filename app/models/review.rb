class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate  :after_checkout, if: "reservation && created_at"

  def after_checkout
    if (reservation.checkout >= created_at.to_date)
      errors.add(:reservation, "Checkout must occur before review.")
    end
  end
end
