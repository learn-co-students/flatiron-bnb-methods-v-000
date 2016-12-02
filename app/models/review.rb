class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating, :reservation_id
  validate :valid_review

private

  def valid_review
    if !self.reservation || self.reservation.status != "accepted" || Date.today < self.reservation.checkout
      errors.add(:reservation_id, "Review is not possible.")
    end
  end
end
