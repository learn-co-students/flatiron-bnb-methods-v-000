class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validate :is_host
 

  validate :trip_dates
 

  def is_host
    errors.add(:guest_id, "guest cannot be host") unless !User.find(self.guest_id).host?
  end

  def trip_dates

    if self.checkin.nil? || self.checkout.nil?
      errors.add(:checkin, "Must have checkin and checkout dates")
    elsif !is_available
      errors.add(:checkin, "not available.")
    elsif self.checkin >= self.checkout
      errors.add(:checkin, "must be at least one day before checkout.")
    end
  end

  def is_available
    listing.available(self.checkin, self.checkout)
  end


end
