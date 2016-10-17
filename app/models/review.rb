class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  validate :invalid_review


  def invalid_review
    if !(self.reservation && reservation.status == "accepted" && reservation.checkout < Date.today)
      errors.add(:inv, "Invalid")
    end
  end
end
