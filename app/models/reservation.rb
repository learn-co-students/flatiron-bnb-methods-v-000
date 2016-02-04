class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates_presence_of :checkin, :checkout
  validate :not_host, :available, :checkin_before_checkout

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end

  private
    def not_host
      if listing.host == self.guest
        errors.add(:guest, "#{guest.name} cannot be host")
      end
    end

    def available
      if listing.not_available_dates.include?self.checkin
        errors.add(:guest,"checkin date not available")
      elsif listing.not_available_dates.include?self.checkout
        errors.add(:guest,"checkout date not available")
      end
    end

    def checkin_before_checkout
      if !self.checkin.nil? && !self.checkout.nil? 
        if self.checkin >= self.checkout
          errors.add(:guest,"checkin cannot be before or same as checkout")  
        end
      end
    end
end
