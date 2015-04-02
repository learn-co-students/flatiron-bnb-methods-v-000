class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :guest_and_host_not_the_same, :check_availablity, :checkout_after_checkin

  # Returns the length (in days) of a reservation
  def duration
    (self.checkout - self.checkin).to_i
  end

  # Given the duration of the stay and the listing price, returns how much does the reservation costs
  def total_price
    self.listing.price * duration
  end

  # private
  # Make sure guest and host not the same
  def guest_and_host_not_the_same
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end

  # Check if listing is available for a reservation request
  def check_availability
    query = "select * from reservations where listing_id = #{self.id} AND '#{self.checkin}' between checkin AND checkout AND '#{self.checkout}' between checkin and checkout"
    return errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.") if Reservation.find_by_sql(query).size > 0
    return true
  end

  # Checks if checkout day happens after checkin day
  def checkout_after_checkin
    if self.checkout && self.checkin
      if self.checkout <= self.checkin
        errors.add(:guest_id, "Your checkin date needs to be after your checkout date")
      end
    end
  end

end
