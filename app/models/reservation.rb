class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

# Validations
  validates_presence_of :checkin, :checkout

  # Compares host id with guest id to prevent reserving at own listing
  validate :not_host?
    def not_host?
      listing = Listing.find(self.listing_id)

      if listing.host_id == self.guest_id
        errors.add(:listing_id, "You cannot be a guest at your own listing.")
      end
    end

  # Checks to see if any current reservations overlap the given dates
  validate :available?
    def available?
      listing = Listing.find(self.listing_id)

      # Find reservations from listing that block this reservation, excluding itself if this is an edit
      # All reservations will block if:
      #     Their checkout dates are after this reservation's checkin date AND 
      #     if their checkin dates are before this reservation's checkout date
      blocking_reservations =  listing.reservations.where(
        "checkout > ? AND checkin < ? AND id != ?", # where statement
         self.checkin, self.checkout, self.id || 0) # parameters

      if blocking_reservations.count > 0
        errors.add(:guest, "This listing is unavailable on those dates.")
      end
    end

  # Checks that checkout is after the check-in date. 
  # If checkout minus checkin is less than or equal to 0, checkout is the same date or before checkin and invalid.
  validate :valid_reservation_period?
    def valid_reservation_period?
      if self.checkout.is_a?(Date) && self.checkin.is_a?(Date) && (self.checkout.to_date - self.checkin.to_date).to_i <= 0 
          errors.add(:checkout, "Checkout date needs to be after the check-in date.") 
      end
    end


# Search methods
  def duration
    (self.checkout.to_date - self.checkin.to_date).to_i
  end

  def total_price
    self.listing.price * duration
  end

end


# Diagram to finding blocking reservations with given dates:
#   
#       ______________          As demonstrated on the right,
#       |             |         where the empty rectangles 
#   ------------      |         are the reservations and 
#   |###########|     |         the filled rectangles are the blocking reservations:
#   |###########|_____|
#   ------------                1-  The blocking reservation's start date is always
#                               before the given ending date.
#                               2-  The blocking reservation's end date is always
#      _______________          after the give starting date.
#      |              |     
#      |       ------------ 
#      |       |###########| 
#      |_______|###########|
#              -------------
# 
#      _______________________
#      |                     |
#      |     -----------     |
#      |     |##########|    |
#      |_____|##########|____|
#            ------------
#   
#             ___________
#            |           |
#     ---------------------------
#     |##########################|
#     |##########################|
#     ----------------------------
# 
