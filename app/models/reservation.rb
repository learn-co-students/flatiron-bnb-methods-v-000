class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin
  validates_presence_of :checkout
  validate :no_res_for_host, :available, :min_one_day_stay

  def duration
    if checkin && checkout
      (checkout - checkin).to_i
    end
  end

  def total_price
    if duration
      self.listing.price*duration
    end
  end

private

  def no_res_for_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest, "cannot be the host and the guest.")
    end
  end

  def available
    reservation = Reservation.where(listing_id: listing_id)
    if checkin && checkout
      reservation.each do |res|
        if id == res.id
          break
        elsif checkin.between?(res.checkin, res.checkout)
          errors.add(:checkin, "Listing is unavailable")
        elsif checkout.between?(res.checkin, res.checkout)
          errors.add(:checkout, "Listing is unavailable")
        end
      end
    end
  end

  def min_one_day_stay
    if duration && duration <= 0
      errors.add(:checkout, "This reservation is only for one day.")
    end
  end
end
