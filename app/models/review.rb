class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true

  validate :valid_review

  private

  def valid_review
    unless self.reservation && self.reservation.status == "accepted" && self.reservation.checkout < Date.today
      errors.add(:valid_review, "You can't leave a review")
    end
  end

end
