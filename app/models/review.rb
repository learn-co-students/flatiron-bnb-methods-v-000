class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :reservation, :description, presence: true
  validate :checked_out

  private

  def checked_out
    if !self.reservation || self.reservation.checkout > Date.today || self.reservation.status != 'accepted'
      errors.add(:reservation, 'You are not eligible to leave a review at this time.')
    end
  end

end
