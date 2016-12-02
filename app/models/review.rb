class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true
  validate :valid_review?

  def valid_review?
    if reservation.nil? || reservation.status != "accepted" || reservation.checkout.to_date >= Date.today
      errors.add(:review, "Can only write a review after checkout")
    end
  end


end
