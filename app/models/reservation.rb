class Reservation < ActiveRecord::Base
  
  validates :checkin, :checkout, presence: true
  validate :cannot_make_reservation_on_own_listing
  validate :same_checkin_and_checkout_date
  validate :checkin_not_before_checkout
  validate :listing_available
  
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
  
  def listing_available
    t1 = self.checkin
    t2 = self.checkout
      # if !self.listing.is_available?(t1,t2)
      #   self.errors[:listing] << "this cannot be done!"
      # end
  end
  
  def checkin_not_before_checkout
    if !self.checkin.nil? && !self.checkout.nil?
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
