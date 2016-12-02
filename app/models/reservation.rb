class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_is_not_host, :checkin_available, :checkout_available, :trip_length

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price.to_f * duration
  end

  private
    def guest_is_not_host
      if self.guest == self.listing.host
        errors.add(:guest, "cannot make a reservation on your own listing")
      end
    end

    def checkin_available
      if checkin && checkout && (listing.booked?(checkin, checkin) || checkin > checkout)
        errors.add(:checkin, "invalid checkin date")
      end
    end

    def checkout_available
      if checkout && listing.booked?(checkout, checkout)
        errors.add(:checkout, "invalid checkout date")
      end
    end

    def trip_length
      if checkin == checkout
        errors.add(:checkout, "checkout must be after checkin")
      end
    end

end
