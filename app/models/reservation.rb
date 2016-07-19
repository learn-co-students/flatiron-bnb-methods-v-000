class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :guest_not_host, :checkout_after_checkin, :available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private

  def guest_not_host # Confirms that guest and host aren't the same user
    if listing.host.id == guest_id
      errors.add(:guest_id, "You can't book your own listing.")
    end
  end

  def checkout_after_checkin # Confirms that checkout is after checkin
    if checkin && checkout && checkout <= checkin
      errors.add(:guest_id, "Checkout date must be after checkin date.")
    end
  end

  def available # Confirms no conflicts among reservations
    unless self.checkin.nil? || self.checkout.nil?
      listing.reservations.each do |reservation|
        # Returns a range of dates from checkin ~ checkout for each listing
        reserved = reservation.checkin..reservation.checkout
        # If user-selected checkin/checkout dates are within range of a reserved booking
        if reserved === self.checkin || reserved === self.checkout
          errors.add(:guest_id, "The dates you've selected are already booked.")
        end
      end
    end
  end
end