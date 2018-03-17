class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  
  validates_presence_of :checkin, :checkout
  validate :not_own_listing
  validate :listing_available?
  validate :checkin_b4_checkout?
  validate :checkin_not_same_as_checkout?
  
  def duration
    checkout - checkin
  end
  
  def total_price
    listing.price * duration
  end
  
  private
  
  def listing_available?
    listing.reservations.each do |res|
      date_range = res.checkin .. res.checkout
      if date_range === self.checkin || date_range === self.checkout
        errors.add(:guest_id, "That reservation date won't work!")
      end
    end
  end
  
  def checkin_b4_checkout?
    unless checkin && checkout && checkin < checkout
      errors.add(:guest_id, "You need to check out AFTER you check in!")
    end
  end
  
  def checkin_not_same_as_checkout?
    unless checkin && checkout && checkin != checkout
      errors.add(:guest_id, "You can't check in and checkout at the same time!")
    end
  end
  
  def not_own_listing
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't reserve one of your own listings!")
    end
  end
end
