class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validates :status, presence: true
  validate :host_is_not_guest
  validate :checkin_is_before_checkout
  validate :checkin_is_not_equal_to_checkout
  validate :listing_is_available

  def duration 
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * self.duration
  end 

  private

  def listing_is_available
    return unless errors.blank? 
    if !self.listing.available?(self.checkin)
      errors.add(:listing, "is not available")
    elsif !self.listing.available?(self.checkout)
      errors.add(:listing, "is not available")
    end
  end

  def host_is_not_guest
    if self.listing.host == self.guest
      errors.add(:guest, "can't be same as host")
    end
  end

  def checkin_is_before_checkout
    if self.checkin && self.checkout && self.checkin > self.checkout
      errors.add(:checkin, "can't be after checkout")
    end
  end

  def checkin_is_not_equal_to_checkout
    return unless errors.blank?
    if self.checkin && self.checkout && self.checkin == self.checkout
      errors.add(:checkin, "can't equal checkout")
    end
  end

end
