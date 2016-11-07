class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_your_own_listing?
  validate :available_at_checkin?
  validate :available_at_checkout?
  validate :checkin_before_checkout?

  #private

    def not_your_own_listing?
      if self.guest_id == self.listing.host_id
        errors.add(:guest, "Guest and host can't be the same user.")
      end
    end

    def available_at_checkin?
      self.listing.reservations.each do |reservation|

        if self.checkin && self.checkout && self.checkin <= reservation.checkin && self.checkout >= reservation.checkout
          errors.add(:checkin, "Reservation already made for this date.")
        end
      end
    end

    def available_at_checkout?
      self.listing.reservations.each do |reservation|
        if self.checkin && self.checkout && self.checkout >= reservation.checkin && self.checkout <= reservation.checkout
          errors.add(:checkout, "Reservation conflicts with another reservation")
        end
      end
    end

    def checkin_before_checkout?
      if checkin && checkout && checkin >= checkout
        errors.add(:checkin, "Checkin cannot be after checkout")
      end
    end

    def duration
      checkout - checkin
    end

    def total_price
      listing.price * duration
    end



end
