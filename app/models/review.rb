class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  
  validate :reservation_accepted, :checkout_past

  def reservation_accepted
    if rating && description && reservation
      errors.add(:reservation, "Reservation must be accepted") unless reservation.status == "accepted"
    end
  end

  def checkout_past
    if rating && description && reservation
      errors. add(:reservation, "Reservation checkout must be in the past.") unless reservation.checkout.past?
    end
  end
end
