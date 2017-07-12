class Reservation < ActiveRecord::Base

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :not_same_user?, :is_available?, :checkout_after_checkin?

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private

  def not_same_user?
    if guest_id == listing.host_id
      errors.add(:guest_id, "Guest and Host cannot be the same.")
    end
  end

  def is_available?
    #if checkin && checkout
    #  if listing.reservations.find {|existing_reservation| (checkin <= existing_reservation.checkout) || (checkout >= existing_reservation.checkin)}
    #    errors.add(:guest_id, "Cannot overlap with an existing reservation.")
    #  end
    #end
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def checkout_after_checkin?
    if checkin && checkout && checkin >= checkout
        errors.add(:guest_id, "Checkout date must be after checkin date.")
    end
  end

end
