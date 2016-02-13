class Review < ActiveRecord::Base
  	belongs_to :reservation
 	belongs_to :guest, :class_name => "User"
	validates_presence_of :rating, :description
	validate :check_reservation_occurred

	private
		def check_reservation_occurred
			unless Reservation.exists?(reservation_id) && Reservation.find(reservation_id).status == "accepted" && Date.today >= Reservation.find(reservation_id).checkout
				errors.add(:reservation_id, "You must have completed your reservation to leave a review.")
			end
		end

end
