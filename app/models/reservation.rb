class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  # Returns the length (in days) of a reservation
  def length
    (self.checkout - self.checkin).to_i
  end

  # Given the length of the stay and the listing price, returns how much does the reservation costs
  def total_price
    self.listing.price * length
  end
end
