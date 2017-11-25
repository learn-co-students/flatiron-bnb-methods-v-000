class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_is_not_host
  validate :checkout_after_checkin
  validate :is_available?


  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

  private

    def guest_is_not_host
      if listing.host.id == guest_id
        errors.add(:guest_id, "You cannot reserve your own listing.")
      end
    end

    def checkout_after_checkin
      if checkin && checkout && checkout <= checkin
        errors.add(:guest_id, "Your checkout date cannot be before your checkin date.")
      end
    end

    def is_available?
      if checkout && checkin
        listing.reservations.each do |reservation|
          if reservation.checkin <= checkout && reservation.checkout >= checkin
            errors.add(:reservation, "These dates are unavailable.")
          end
        end
      end
    end

end
