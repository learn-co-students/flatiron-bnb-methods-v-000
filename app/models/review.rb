class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :eligible_for_review


  def eligible_for_review
    if !self.reservation || self.reservation.checkout > Date.today || self.reservation.status != "accepted"
      errors.add(:reservation, "This reservation is not eligible for a review.")
    end
  end

end
