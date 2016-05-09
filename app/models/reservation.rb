class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :not_your_own
  validate :valid_dates

  def duration
    self.checkout - self.checkin
  end

  def total_price
    duration * self.listing.price
  end

  private

    def not_your_own
      if self.guest_id == self.listing.host_id
        errors.add(:own_listing, 'You cannot book your own listing.')
      end
    end

    def valid_dates
      correct_dates
      check_availability
    end

    def correct_dates
      if self.checkin && self.checkout
        if self.checkout <= self.checkin
          errors.add(:guest_id, 'Please check your dates!  Check in must be before checkout time.')
        end
      end
    end

    def check_availability
      if !self.checkin.nil? && !self.checkout.nil?
        self.listing.reservations.each do |reservation|
          dates = reservation.checkin..reservation.checkout

          if dates === self.checkin || dates === self.checkout
            errors.add(:guest_id, "Dates unavailable.")
          end
        end
      end
    end

end
