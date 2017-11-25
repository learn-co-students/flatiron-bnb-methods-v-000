class AcceptedAndCheckedOutValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.reservation && record.reservation.accepted? && Date.today > record.reservation.checkout
      record.errors[:reservation_id] << "The associated reservation but be accepted and have finished."
    end
  end
end
