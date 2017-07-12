class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :reservation_status, :checkout_in_past

  def reservation_status
    if reservation && reservation.status != "accepted"
      errors.add(:reservation, "must be accepted")
    end
  end

  def checkout_in_past
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "checkout must be in the past")
    end
  end

end
