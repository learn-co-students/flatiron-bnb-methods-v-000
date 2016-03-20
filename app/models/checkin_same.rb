

class CheckinSame < ActiveModel::Validator
	def validate(record)
		if !record.checkin.nil? && !record.checkout.nil? &&  record.checkin == record.checkout
			record.errors[:checkin] << "Check-in time cannot be same as check-out time"
		end
	end
end