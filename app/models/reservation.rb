class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :prevent_user_reserving_own_reservation, :checkin_available, :checkout_available, :checkout_before_checkin

  def duration
    checkout - checkin
  end

  def total_price
    price = listing.price
    duration * price
  end

  private

  def prevent_user_reserving_own_reservation
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "Cannot book your own reservation")
    end
  end

  def checkout_before_checkin
    if checkin && checkout && checkout <= checkin
      errors.add(:guest_id, "Checkout cannot be before checkin")
    end
  end

  def checkin_available
    # check all reservations for the listing to make sure no overlapping dates
    listing.reservations.each do |reservation|
      array = (reservation.checkin..reservation.checkout).to_a
      if array.include?(checkin)
        errors.add(:checkin, "Date chosen has already been reserved")
      end
    end
  end

  def checkout_available
    # check all reservations for the listing to make sure no overlapping dates
    listing.reservations.each do |reservation|
      array = (reservation.checkin..reservation.checkout).to_a
      if array.include?(checkout)
        errors.add(:checkout, "Date chosen has already been reserved")
      end
    end
  end

end
