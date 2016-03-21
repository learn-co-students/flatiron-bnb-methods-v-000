class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

 validate :host_cannot_make_reservation, :checkin_availability, :checkin_before_checkout

  def duration

    (self.checkout - self.checkin).to_i
  end

  def total_price
    duration * self.listing.price.to_i
  end


private
  def host_cannot_make_reservation
      if self.listing.host_id == self.guest_id
        errors.add(:guest_id, "You can't book your own apartment")
      end
  end

  def checkin_availability

  self.listing.reservations.each do |r|

      booked_dates = r.checkin..r.checkout
      if booked_dates === self.checkin || booked_dates === self.checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def checkin_before_checkout

    if self.checkin && self.checkout
      if self.checkout <= self.checkin
        errors.add(:guest_id, "Sorry, your checkout date can't be before your checkin date.")
      end
    end
  end
  #check the reservation dates
  # check the start date for the reservation
  # have to check the checking and checkout dates and block that.
  # check to see if the start date is within that block.

end
