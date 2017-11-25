class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :reservation_valid?

  def reservation_valid?
    errors.add(:reservation, 'cannot leave review.') if self.reservation_id == nil || self.reservation.status != "accepted" || self.reservation.checkout > DateTime.now.to_date
  end

end
