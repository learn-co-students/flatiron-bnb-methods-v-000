class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  has_one :review

  validates :checkin, :checkout, presence: true  
  validate :invalid_same_ids, :available, :checkin_before_checkout?, :checkin_checkout_same?

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end     

  def invalid_same_ids
    errors.add(:guest_and_host, "can't be the same") if guest_id == listing.host_id    
  end

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def checkin_before_checkout?
    if checkin && checkout && checkin > checkout
      errors.add(:guest_id, "Check-in date can not be after check-out date.") 
    end
  end

  def checkin_checkout_same?
    if checkin && checkout && checkin == checkout
      errors.add(:guest_id, "Check-in date and check-out date can not be the same.") 
    end
  end

end
