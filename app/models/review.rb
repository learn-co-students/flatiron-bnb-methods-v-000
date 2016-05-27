class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation_id
  validate :reservation_exists
  validate :reservation_valid

  def reservation_exists
    if self.reservation.nil? 
      errors.add(:review, "This is not a valid reservation.")
    end
  end

  def reservation_valid
    if self.reservation && (!self.reservation.status == "accepted" || !self.reservation.checkout.past?)
       errors.add(:review, "You cannot review this reservation.")
    end
  end

end
