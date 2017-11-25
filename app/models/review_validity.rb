class ReviewValidity < ActiveModel::Validator

  def validate(record)
    binding.pry
    reservation = Reservation.find_by(id: record.reservation_id)
    
    unless reservation.checkout || reservation == nil
      record.errors[:checkout] << 'No review possible without checkout'
    end
  end

end