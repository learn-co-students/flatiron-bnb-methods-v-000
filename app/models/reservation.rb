class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  validate :guest_and_host_not_the_same, :check_availablity

  # Returns the length (in days) of a reservation
  def length
    (self.checkout - self.checkin).to_i
  end

  # Given the length of the stay and the listing price, returns how much does the reservation costs
  def total_price
    self.listing.price * length
  end

  # Make sure guest and host not the same
  def guest_and_host_not_the_same
    if self.guest_id == self.listing.host_id
      errors.add(:guest, "You can't book your own apartment")
    end
  end

  # Check if listing is available for a reservation request
  def check_availablity
    self.listing.reservations.each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === self.checkin || booked_dates === self.checkout
        errors.add(:guest, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  # Makes a new reservation object given if its available
  def book!
  end

end
