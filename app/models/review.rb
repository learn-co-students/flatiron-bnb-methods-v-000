class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description

  validate :appropriate_review_time
  # validate :appropriate_review_time

  def appropriate_review_time
    if self.reservation == nil || self.reservation.status != "accepted"
      self.errors.add(:base, "You can't leave a review without a reservation")
    elsif self.reservation.checkout > Date.today
      self.errors.add(:base, "Your stay hasn't ended yet!")
    end
  end

end
