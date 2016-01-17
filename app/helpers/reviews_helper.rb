module ReviewsHelper

  class AlreadyStayedValidator < ActiveModel::Validator
    def validate(record)
      if record.reservation
        if !record.reservation.checkout.past?
          record.errors[:base] << "Cannot review a trip that has not happened yet."
        end
      end
    end
  end

end