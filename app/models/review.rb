class Review < ActiveRecord::Base
	belongs_to :reservation
	belongs_to :guest, :class_name => "User"

	validates :rating, presence: true, numericality: {
		greater_than_or_equal_to: 0,
		less_than_or_equal_to: 5,
		only_integer: true
	}

	validates :description, :reservation, presence: true

	validate :checked_out, :reservation_accepted 

	private

	def checked_out
		errors.add(:reservation, "Reservation must have ended to leave a review.") if reservation && reservation.checkout > Date.today
	end

	def reservation_accepted
		errors.add(:reservation, "Reservation must be accepted to leave a review.") if reservation.try(:status) != 'accepted'
	end
end
