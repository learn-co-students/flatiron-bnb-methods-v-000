class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
    validate :own_listing?, :check_availability, :checkin_time, :valid_dates

    def duration
      (self.checkout - self.checkin).to_i
    end

    def total_price
      listing.price * duration
    end

  private

    def own_listing?
      if self.guest_id == self.listing.host_id
        errors.add(:guest_id, "That's your own listing.")
      end
    end

    def check_availability
      self.listing.reservations.each do |r|
        booked_dates = r.checkin..r.checkout
        if booked_dates.include?(self.checkin) || booked_dates.include?(self.checkout)
          errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
        end
      end
    end

    def checkin_time
      if self.checkout && self.checkin
        if self.checkout <= self.checkin
          errors.add(:guest_id, "Checkout time must be after checkin time.")
        end
      end
    end

    def valid_dates
      if self.checkin == self.checkout
        errors.add(:guest_id, "Invalid reservation timeframe.")
      end
    end
  end

