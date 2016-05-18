class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  validate :eligable_review

  def eligable_review
    if !reservation || reservation.checkout > Date.today || reservation.status != 'accepted'
      errors.add(:reservation, 'You cannot leave a review for this listing.')
    end
  end

end
