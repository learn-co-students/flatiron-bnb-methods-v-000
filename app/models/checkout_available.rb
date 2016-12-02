

class CheckoutAvailable < ActiveModel::Validator
	def validate(record)
		if !record.checkout.nil? && record.listing.reservations.any? do |x|
			!x.checkout.nil? && record.checkout > x.checkin && record.checkout < x.checkout
			
		end
		record.errors[:checkout] << "Check-out time must be available"
	end
	end
end