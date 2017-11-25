class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :can_review

  private

  def can_review
    if !reservation || reservation.checkout > Date.today || reservation.status != "accepted"
      errors.add(:review, "Sorry but you cannot review this.")
    end
  end

end
