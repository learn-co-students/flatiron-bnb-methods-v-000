class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :accepted_reservation
  validate :checked_out


  def accepted_reservation
    if reservation && reservation.status == "accepted" 
    else
      errors.add(:base, "Reservation must be accepted first!")
    end
  end

  def checked_out
    if reservation && reservation.checkout < Date.today
    else
      errors.add(:base, "Check out first, review later!")
    end
  end

end
