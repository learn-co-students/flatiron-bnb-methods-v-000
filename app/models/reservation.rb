class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :not_host
  validate :available
  validate :checkout_after_checkin

  def duration
    (self.checkout - self.checkin).to_i
  end

  def not_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end

  def total_price
     self.listing.price * duration
  end

  def checkout_after_checkin
    if self.checkout && self.checkin
      if self.checkout <= self.checkin
        errors.add(:guest_id, "Your checkin must be before your checkout")
      end
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

end
