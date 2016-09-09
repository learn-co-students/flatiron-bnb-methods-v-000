class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :host_is_not_guest, :checkout_after_checkin, :checkin_checkout_different, :is_available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  def host_is_not_guest
    if guest_id == listing.host_id
      errors.add(:guest_id, "You own this listing, you cannot book it.")
    end
  end

  def is_available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |reservation|
      if ((checkin > reservation.checkin) && !(checkin > reservation.checkout)) || ((checkin < reservation.checkin) && !(checkout < reservation.checkin))
        errors.add(:guest_id, "This rental is already booked during those dates.")
      end
    end
  end

  def checkin_checkout_different
    if checkin == checkout
      errors.add(:guest_id, "Checkin and checkout dates cannot be the same.")
    end
  end

  def checkout_after_checkin
    if checkout && checkin && checkout <= checkin
      errors.add(:guest_id, "Your checkout date needs to be after your checkin.")
    end
  end

end
