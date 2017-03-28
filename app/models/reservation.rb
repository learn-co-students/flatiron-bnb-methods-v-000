class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  
  validate :invalid_checkin_checkout
  validate :invalid_own_listing
  validate :invalid_dates

  def invalid_checkin_checkout
    if !self.checkin.nil? && !self.checkout.nil?
      if self.checkin >= self.checkout 
        errors.add(:invalid_dates, "Dates are invalid")
      end
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price  
    listing.price * duration
  end

  def invalid_own_listing
    if listing_id == guest_id
      errors.add(:own_listing, "Can't reserve own place")
    end
  end

  def invalid_dates
    self.listing.reservations.each do |res|
      existing_reservations = res.checkin..res.checkout 
      if existing_reservations.include?(self.checkin) || existing_reservations.include?(self.checkout)
        errors.add(:checkin_taken, "The date is already taken")
      end
    end 
  end


end #ends class
