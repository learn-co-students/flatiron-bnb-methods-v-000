class Reservation < ActiveRecord::Base
  	belongs_to :listing
	belongs_to :guest, :class_name => "User"
	has_one :review
	validates :checkin, presence: true
	validates :checkout, presence: true
	validate :guest_not_host, :check_availability, :checkin_before_checkout

	def duration
		(self.checkout - self.checkin).to_i
	end

	def total_price
		(self.listing.price * self.duration).to_i
	end

	private
		def guest_not_host
			if self.guest_id == self.listing.host_id
				errors.add(:guest_id, "You can't book your own listing")
			end
		end

		def check_availability
			self.listing.reservations.each do |reservation|
				booked_dates = reservation.checkin..reservation.checkout
				if booked_dates === self.checkin || booked_dates === self.checkout
					errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
				end
			end
		end

		def checkin_before_checkout
			if self.checkout && self.checkin
				if self.checkin >= self.checkout
					errors.add(:guest_id, "Checkin date must be before checkout date.")
				end
			end
		end

end
