class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  validate :associations

  def associations
    if !self.reservation || self.reservation.status != "accepted" || self.reservation.checkout > Date.today
      errors.add(:associations, "bad")
    end
  end

end
