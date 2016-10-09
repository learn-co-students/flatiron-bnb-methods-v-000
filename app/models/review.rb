class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :checkout_has_happened, :reservation_accepted

  def checkout_has_happened
     if reservation && reservation.checkout > Date.today
       errors.add(:reservation, "Checkout must have happened.")
     end
   end

   def reservation_accepted
     if reservation.try(:status) != 'accepted'
       errors.add(:reservation, "Reservation must be accepted.")
     end
 end

end
