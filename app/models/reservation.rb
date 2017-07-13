class Reservation < ActiveRecord::Base
  validates :checkin, :checkout, presence: true
  validate :host_cannot_stay, :is_available, :checkin_before_checkout

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def duration
    if checkin && checkout
      checkout.mjd - checkin.mjd
    end
  end

  def total_price
    listing.price * duration
  end

  private
    def host_cannot_stay
      if listing.host == guest
        errors.add(:guest_id, "cannot be the same as host")
      end
    end

    def is_available
      if checkin && checkout
        listing.reservations.each do |res|
          if res.checkin <= checkout && checkin <= res.checkout
            errors.add(:is_available, "this listing is not available")
          end
        end
      end
    end

    def checkin_before_checkout
      if checkin && checkout
        errors.add(:checkin_before_checkout, "checkin must be before checkout") if checkin >= checkout
      end
    end
end
