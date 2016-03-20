

class ValidateRes < ActiveModel::Validator
	def validate(record)
		if record.listing.host == record.guest
			record.errors[:guest_id] << "Cannot make a reservation on your own listing"
		end
	end
end