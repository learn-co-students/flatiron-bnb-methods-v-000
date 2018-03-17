class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, numericality: { only_integer: true,
                                     greater_than: 0,
                                        less_than: 6 }

  validate :guest_status

  private
    def guest_status
      if !self.reservation || Date.today < self.reservation.checkout || self.reservation.status != 'accepted'
        errors.add(:user_id, "You can only leave a review after checkout.")
      end
    end
end
