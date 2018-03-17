class ReservationComplete < ActiveModel::Validator
  def validate(record)
    if record.reservation_id == nil
      record.errors[:reservation_id] << 'Reviews are only valid with a reservation.'
    elsif record.reservation.status != "accepted"
      record.errors[:reservation_id] << 'Reviews are only valid with accepted reservations'
    elsif record.created_at == nil
      # do nothing
    elsif record.reservation.checkout >= record.created_at
      record.errors[:created_at] << 'Reviews can only be written after a completed reservation.'
    end
  end
end
