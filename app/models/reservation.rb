class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :guest_cannot_be_host
  validate :listing_is_available
    
 
  def guest_cannot_be_host
    if self.listing.host_id == self.guest_id 
      errors.add(:guest_is_host, "can't reserve own listing")
    end
  end

  def listing_is_available
  	if self.status != "accepted"
  		errors.add(:invalid_checkin, "listing isn't available for reservation")
  	end
  end

  def duration
  	self.checkout - self.checkin
  end

  def total_price
  	self.listing.price * duration

  end

end
