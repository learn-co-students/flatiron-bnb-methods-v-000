class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :checkout_passed

  def checkout_passed
    if self.reservation_id && Date.today < self.reservation.checkout
      errors.add(:checkout_has_not_passed, "cannot write reviews until the checkout date has passed")
    end
  end

end
