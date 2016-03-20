

class CheckinBefore < ActiveModel::Validator
	def validate(record)
		if !record.checkin.nil? && !record.checkout.nil? &&  record.checkin >= record.checkout
			record.errors[:checkin] << "Check-in must be before check-out"
		end
	end
	
end