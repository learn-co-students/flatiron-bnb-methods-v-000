class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description

  validate :can_review

  private

  def can_review
    if !reservation || reservation.checkout > Date.today || reservation.status != "accepted"
      errors.add(:review, "Review cannot be made.")
    end
  end

end
