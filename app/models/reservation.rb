class Reservation < ActiveRecord::Base
  
  validates :checkin, :checkout, presence: true
  validate :cannot_make_reservation_on_own_listing
  validate :same_checkin_and_checkout_date
  validate :listing_validations
  
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  
  def cannot_make_reservation_on_own_listing
    if self.guest == self.listing.host
      self.errors[:guest] << "this cannot be done!"
    end
  end
  
  def same_checkin_and_checkout_date
    if self.checkin == self.checkout
      self.errors[:checkin] << "this cannot be done!"
    end
  end
  
  def listing_validations
    if !self.checkin.nil? && !self.checkout.nil?

      t1, t2 = self.checkin, self.checkout
      self.listing.reservations.each do |reservation|
        if t1 <= reservation.checkout && reservation.checkin <= t2
          self.errors[:listing] << "bad"
        end
      end

      if self.checkin > self.checkout
        self.errors[:checkin] << "this cannot be done!"
      end

    end
  end
  
  def duration
    (self.checkout - self.checkin).to_i
  end
  
  def total_price
    self.duration * self.listing.price
  end
  
  

end
