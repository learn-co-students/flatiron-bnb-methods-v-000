require 'pry'

class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_many :guests, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_isnt_host
  validate :reservations_dont_conflict
  validate :checkout_is_after_checkin
  validate :checkout_is_not_checkin

    def guest_isnt_host
        if self.guest_id == self.listing.host_id
              errors.add(:guest_id, "Guest and Host cannot be same user")
       end
    end

    def checkout_is_after_checkin
        if self.checkout && self.checkin
            if self.checkout < self.checkin
                  errors.add(:checkout, "Checkout must be after checkin")
           end
       end
    end

    def checkout_is_not_checkin
        if self.checkout && self.checkin
            if self.checkout == self.checkin
                  errors.add(:checkout, "Checkout cannot be same day as checkin")
           end
       end
    end

    def reservations_dont_conflict
         if self.checkout && self.checkin
            Reservation.all.each do |reservation|
                if overlaps?(checkin, checkout, reservation)
                    errors.add(:checkin, "Reservation dates are not available")
                end
            end
        end
    end

     def overlaps?(start_date, end_date, other)
        # binding.pry
        (start_date - other.checkout) * (other.checkin - end_date) >= 0
     end

    def duration
        if self.checkout && self.checkin
            self.checkout - self.checkin
        end
    end

    def total_price
        self.listing.price * duration
    end

end
