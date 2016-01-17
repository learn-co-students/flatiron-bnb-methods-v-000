module ReservationsHelper

  class GuestUniqueFromHostValidator < ActiveModel::Validator
    def validate(record)
      if record.guest_id == record.listing.host_id
        record.errors[:base] << "A user cannot reserve their own listing."
      end
    end
  end

  class ListingAvailabilityValidator < ActiveModel::Validator
    def validate(record)
      if record.checkin != nil && record.checkout != nil
        record.listing.reservations.each do |a|
          if record.checkin.between?(a.checkin, a.checkout) ||
            record.checkout.between?(a.checkin, a.checkout)
            record.errors[:base] << "Listing is already booked at your requested date."
          end
        end
      else
        record.errors[:base] << "Checkin and Checkout must have values."
      end
    end
  end

  class OutAfterInValidator < ActiveModel::Validator
    def validate(record)
      if record.checkin != nil && record.checkout != nil
        if record.checkin >= record.checkout
          record.errors[:base] << "Checkout date must be after Checkin date."
        end
      end
    end
  end

end
