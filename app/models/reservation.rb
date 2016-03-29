class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :guest_not_host, :listing_available, :valid_dates

  def duration
    (Date.parse(self.checkout.to_s) - Date.parse(self.checkin.to_s)).to_i
  end

  def total_price
    self.listing.price * duration
  end

  private
  def guest_not_host
    if self.listing.host == self.guest
      errors.add(:guest_id, "You are unable to create a reservation on own listing")
    end
  end

  def listing_available
    if self.checkin && self.checkout
      if self.listing.reservations.any? do |reservation|
        (Date.parse(self.checkin.to_s) - Date.parse(reservation.checkout.to_s)) * (Date.parse(reservation.checkin.to_s) - Date.parse(self.checkout.to_s)) >= 0
      end
        errors.add(:checkin, "invalid date")
      end
    end
  end

  def valid_dates
    if self.checkin && self.checkout
      if Date.parse(self.checkin.to_s) - Date.parse(self.checkout.to_s) >= 0
        errors.add(:checkin, "invalid date")
      end
    end
  end

end
