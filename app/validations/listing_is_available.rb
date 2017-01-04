class ListingIsAvailable < ActiveModel::Validator
  def validate(record)
    if record.checkin == nil || record.checkout == nil
      #do nothing
    else
      conflict_exists = record.listing.reservations.any? do |reservation|
      !((record.checkout < reservation.checkin) || (record.checkin > reservation.checkout))
    end
  if conflict_exists
    record.errors[:checkin] << 'These dates not available'
  end
end
  end
end

#
# class GuestIsNotHost < ActiveModel::Validator
#   def validate(record)
#     if record.listing.host == record.guest
#       record.errors[:guest] << 'Host cannot be a guest.'
#     end
#   end
# end
