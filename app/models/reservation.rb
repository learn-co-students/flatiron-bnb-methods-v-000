class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates_presence_of :checkin, :checkout
  validate :host_not_guest, :available?, :checkout_after_checkin

  def host_not_guest
    if listing.host_id == guest_id
      errors.add(:host_not_guest, "This is your own listing")
    end
  end

  def available?
    if checkin && checkout
      listing.reservations.each do |reservation|
        if reservation.checkin <= checkout && reservation.checkout >= checkin
          errors.add(:available?, "Not Available")
        end
      end
    end
  end

  def checkout_after_checkin
    if checkin && checkout && checkout <= checkin
      errors.add(:checkout_after_checkin, "error")
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

end
