class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, class_name: "User"
  
  # validates :rating, :descripton, :reservation_id, presence: true
  # validate :valid_reservation?
  
  # private
  # def valid_reservation?
  #   if reservation && reservation_status != "accepted" && !reservation.checkout.past?
  #     errors.add(:reservation, "Reservation must be accepted and completed before writing review.")
  #   end
  # end
end
