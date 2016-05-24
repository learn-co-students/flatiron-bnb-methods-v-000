class AvailabilityValidator < ActiveModel::Validator
  def initialize(options)
    @start_date = options[:start_date]
    @end_date = options[:end_date]
  end
  
  def validate(record)
    overlapping_reservations = Reservation.where(
      'listing_id = ? AND checkin <= ? AND 
       checkout >= ? AND reservations.status = ?', 
       record.listing_id,
       record.checkout, 
       record.checkin, 
       'accepted')
    
    unless overlapping_reservations.empty?
      record.errors[:checkin] << "Those dates are already taken."
      record.errors[:checkout] << "Those dates are already taken."
    end
  end
end
