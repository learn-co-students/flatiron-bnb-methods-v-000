class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
   validate :reservation_accepted
  validate :checked_out

 def reservation_accepted
    if reservation && reservation.status != "accepted"
      errors.add(:reservation, "You cannot leave a review as your reservation has not been accepted.")
    end
  end

  def checked_out
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "You cannot leave a review as checkout has not occured.")
    end
  end

end
