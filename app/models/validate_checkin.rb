

class ValidateCheckin < ActiveModel::Validator
	def validate(record)
		if !record.checkin.nil? && record.listing.reservations.any? do |x|
			!x.checkin.nil? && record.checkin >= x.checkin && record.checkin <= x.checkout
		end
		record.errors[:checkin] << "Listing is not available at this checkin time"
		end
	end
end