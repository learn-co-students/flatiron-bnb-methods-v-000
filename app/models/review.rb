class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description, :reservation
  validate :valid_review

  def valid_review
    unless self.reservation && self.reservation.status == "accepted" && self.reservation.checkout <= Date.today
      errors.add(:valid_review, "Please check out before writing a review.")
    end
  end
end
