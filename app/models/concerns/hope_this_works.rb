class HopeThisWorks < ActiveModel::Validator
  def validate(record)
    if record.listing.reservations.any? {|reserve| record.checkin.between?(reserve.checkin, reserve.checkout)} || record.guest_id == record.listing_id
      record.errors[:base] << "Not Available"
    end
  end
end
