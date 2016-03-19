class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates_presence_of :checkin, :checkout
  validate :own_listing?
  validate :available_at_checkin_and_checkout, :dates_ok

  def own_listing?
    if self.guest && self.guest.host
      if self.guest.listings.include?(self.listing)
        errors.add(:reservation, "can't reserve own listing")
      end
    end
  end

  def available_at_checkin_and_checkout
    Reservation.all.each do |reservation|
      if self.listing == reservation.listing && self.id != reservation.id
        if self.checkin && self.checkout 
          if (self.checkin >= reservation.checkin && self.checkin <= reservation.checkout) || 
            (self.checkout <= reservation.checkout && self.checkout >= reservation.checkin)         
           errors.add(:reservation, "listing not available for these dates")
          end
        end
      end
    end
  end

  def dates_ok
    if self.checkin && self.checkout && self.checkin >= self.checkout
      errors.add(:reservation, "Checkin date must be before Checkout date.")
    end
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.duration * self.listing.price
  end

end
