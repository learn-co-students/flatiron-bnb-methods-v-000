class Reservation < ActiveRecord::Base
	belongs_to :listing
	belongs_to :guest, :class_name => "User"
	has_one :review

	validates :checkin, :checkout, presence: true

	validate :guest_is_not_host, :available_at_checkin, :check_out_after_check_in

	# you cannot make a reservation on your own listing
	def guest_is_not_host
		errors.add(:guest, "You can't book your own listings!") if guest == listing.host
	end

	def available_at_checkin
	    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
	      booked_dates = r.checkin..r.checkout
	      if booked_dates === checkin || booked_dates === checkout
	        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
	      end
	    end		
	end

	def check_out_after_check_in
		errors.add(:guest_id, "Your check-out date needs to be after your check-in.") if (checkout && checkin && checkout <= checkin)
	end	

	def duration
		(checkout - checkin).to_i
	end

	def total_price
		listing.price * duration
	end

end
