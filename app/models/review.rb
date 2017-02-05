class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :rez_accepted, :rez_not_passed

  def rez_accepted
    if self.reservation && self.reservation.status != "accepted"
      errors.add(:reservation, "reservation must have status:accepted for valid review")
    end
  end

  def rez_not_passed
    if self.reservation && self.reservation.checkout > Date.today
      errors.add(:reservation, "reservation must be completed")
    end
  end
end
