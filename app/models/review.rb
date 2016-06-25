class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence:true
  validate :comprehensive_review, :real_review

  def comprehensive_review
     if self.reservation != nil 
      if self.reservation.checkout > Date.today
        errors.add(:invalid_review_time, "must complete review after trip is completed")
      end
    end
  end

  def real_review
      if self.reservation == nil
        errors.add(:real_review, "reviews must only be completed for genuine reservations")
      elsif self.reservation.status == "pending"
        errors.add(:real_review, "reviews must only be completed for genuine reservations")
      end 
  end
  # if there isn't a real reservation:
      # if the reservation status is pending
      # if there isn't a reservation_id with it
end
