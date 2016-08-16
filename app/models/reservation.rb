class Reservation < ActiveRecord::Base
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :self_res
  validate :timing
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  def timing
    if self.checkin != nil && self.checkout != nil
      if self.checkin == self.checkout
        errors.add(:checkin, "checkin and checkout cannot be the same")
      elsif self.listing.available?(self.checkin, self.checkout) == false
        errors.add(:checkin, "listing not available at specified time")
      elsif self.checkin > self.checkout
        errors.add(:checkout, "checkout must be after checkin")
          
      end
    end
  end

  def self_res
    if self.guest == self.listing.host
      errors.add(:guest, "cannot reserve your own listing")
    end
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end

end
