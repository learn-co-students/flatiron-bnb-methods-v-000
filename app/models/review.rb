class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true
  validate :checkout_not_passed?

  def checkout_not_passed?
    if reservation_id != nil
      if self.reservation.checkout < Date.today == false
        errors.add(:guest_id, "You didn't finish your stay yet")
      end
    end
  end

end
