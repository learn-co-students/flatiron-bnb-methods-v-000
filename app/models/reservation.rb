class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :my_listing?
  validate :available?, :ok_dates

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  private
    def my_listing?
      if self.guest && self.guest.host
        if self.guest.listings.include?(self.listing)
          errors.add(:reservation, "You can't book your own listing")
        end
      end
    end

    def available?
      Reservation.all.each do |reservation|
        if self.listing == reservation.listing && self.id != reservation.id
          if self.checkin && self.checkout
            if (self.checkin >= reservation.checkin && self.checkin <= reservation.checkout) || 
            (self.checkout <= reservation.checkout && self.checkout >= reservation.checkin)
              errors.add(:reservation, "The listing is not available.")
            end
          end
        end
      end
    end

    def ok_dates
      if self.checkin && self.checkout && self.checkin >= self.checkout
        errors.add(:reservation, "Check in date must be before check out date.")
      end
    end
end
