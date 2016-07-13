class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
	
	validates_presence_of :rating, :description, :reservation
	validate :accepted_reservation
  validate :checked_out
	
	
	def accepted_reservation
		if self.reservation && self.reservation.status == "accepted" 
    else
			errors.add(:reservaion_id, "Reservation must be accepted first!")
    end
  end
	
	def checked_out
		unless reservation && reservation.checkout < Date.today
			errors.add(:reservation_id, "Check out first, review later!")
		end
	end
end
