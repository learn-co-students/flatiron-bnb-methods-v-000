class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout


  validate :guest_is_not_host
  validate :dates_available
  validate :check_out_after_checkin

  def duration
    (checkout - checkin).to_i 
  end 

  def total_price
    listing.price * duration 
  end 

private 

  def guest_is_not_host
    if guest_id != listing.host_id
      true
    else
      errors.add(:guest_id, "Sorry - you cannot book your own listing.")
    end 
  end 

  def dates_available
    available = listing.reservations.all? do |reservation|
      reservation.checkin >= checkout || reservation.checkout <= checkin if (checkin && checkout)
    end
    if !available
      errors.add(:listing, "Date range not available, please try again.")
    end
  end 

  def check_out_after_checkin
    if checkout && checkin && checkout <= checkin 
      errors.add(:guest_id, "Checkin cannot be after checkout.")
    end 
  end

end


