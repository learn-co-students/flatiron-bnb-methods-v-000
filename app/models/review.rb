class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation_id
  validate :review_after_reservation

  def review_after_reservation
    if !self.reservation || self.reservation.status != "accepted" || Time.now < self.reservation.checkout
      errors.add(:review, "must happen after valid reservation checkout")
    end
  end

end
