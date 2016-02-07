class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :reserve_your_own_listing, :listing_is_available, :dates_are_ok



  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * duration
  end

  private

  def reserve_your_own_listing
    # guest id and host id can't be the same
    if self.guest_id == listing.host_id
      errors.add(:reserve_your_own_listing, "You can't reserve your own listing")
    end
  end

  def listing_is_available
    # a listing doesn't have a reservation for those dates
    if !self.checkin.nil? && !self.checkout.nil?

      listing.reservations.each do |reservation|
        booked = (reservation.checkin..reservation.checkout)
        if booked === self.checkin || booked === self.checkout
          errors.add(:listing_is_available, "These dates aren't available")
        end
      end
    end
  end

  def dates_are_ok
      if !self.checkin.nil? && !self.checkout.nil?

        if self.checkin >= self.checkout
          errors.add(:dates_are_ok, "Please double-check your dates")
        end
      end
  end

end


# http://stackoverflow.com/questions/4521921/how-to-know-if-todays-date-is-in-a-date-range

# I have an event with start_time and end_time and want to check if the event is "in progress". That would 
# be to check if today's date is in the range between the two dates.
# Use ===
#  Make a Range and compare Time objects to it using the === operator.





