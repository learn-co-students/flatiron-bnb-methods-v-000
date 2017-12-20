class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates_presence_of :checkin, :checkout
  validate :host_and_guest_unique_id
  validate :available, :checkin_before_checkout

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    price_per_night = listing.price
    price_per_night * duration
  end

  private
  def host_and_guest_unique_id
    if guest_id == listing.host_id
      errors.add(:guest_id, "You cannot make a reservation on your own listing")
    end
  end

  def available
    listing.reservations.where.not(id: id).each do |reservation|
      reservation_dates = reservation.checkin..reservation.checkout
      if reservation_dates === checkin || reservation_dates === checkout
        errors.add(:guest_id, "The listing is not available for your dates")
      end
    end
  end

  def checkin_before_checkout
    unless checkin.nil? || checkout.nil?
      if checkin >= checkout
        errors.add(:guest_id, "Checkin Date must be before Checkout Date")
      end
    end
  end
end
