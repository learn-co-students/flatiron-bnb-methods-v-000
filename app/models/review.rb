class Review < ActiveRecord::Base
  validates_presence_of :rating, :description
  validates_associated :reservation
  validate :checked_out
  validate :accepted_res
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  private 

  def checked_out
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reservation must have ended to leave a review.")
    end
  end

  def accepted_res
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Reservation must be accepted to leave a review.")
    end
  end

end
