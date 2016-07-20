class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :guest_not_host, :reservation_date_logic, :available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private

  def guest_not_host
    if listing.host.id == guest_id
      errors.add(:guest_id, "You can't book your own listing.")
    end
  end

  def reservation_date_logic
    if checkin && checkout && checkout <= checkin
      errors.add(:guest_id, "Checkout date must be after checkin date.")
    end
  end

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Please select a different date, the listing is already booked during these dates.")
      end
    end
  end
end
