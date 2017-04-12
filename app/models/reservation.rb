class Reservation < ActiveRecord::Base

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_is_not_the_host, :reservation_available

  def guest_is_not_the_host
    if self.guest_id == Listing.find(self.listing_id).host_id
      errors.add(:guest_id, "guest cannot be the host")
    end
  end

  def reservation_available
    if checkin && checkout
      reservations = Reservation.where("listing_id = ?", listing.id)
      reservations.each do |reservation|
        if reservation.id == id
          break
        elsif (reservation.checkin..reservation.checkout).overlaps?(checkin..checkout)
          errors.add(:guest_id, "reservation dates not available")
        elsif checkout <= checkin
          errors.add(:guest_id, "checkin must proceed checkout")
        end
      end
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price.to_f
  end

end
