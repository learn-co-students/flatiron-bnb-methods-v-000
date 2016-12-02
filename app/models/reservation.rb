class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :not_host, :available, :valid_dates


  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end

  private


    def not_host
      if self.guest_id == self.listing.host_id
        errors.add(:not_host, "You cannot reserve your own listing!")
      end
    end

    def available
      self.listing.reservations.each do |reservation|
        reservation_dates = reservation.checkin..reservation.checkout
          if reservation_dates.include?(self.checkin) || reservation_dates.include?(self.checkout)
            errors.add(:available, "The listing you have chosen is not available for your selected dates. Please choose different dates.")
          end
      end
    end

    def valid_dates
      if self.checkin && self.checkout
        if self.checkin >= self.checkout
          errors.add(:valid_dates, "The check in date is after checkout. Please select a valid date range")
        end
      end
    end


end
