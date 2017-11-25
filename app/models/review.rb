class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating, :reservation
  validate :invalid_review

  private

  def invalid_review
    if !reservation || reservation.checkout > Date.today || reservation.status != 'accepted'
      errors.add(:reservation, "Your review cannot be accepted.")
    end
  end
end