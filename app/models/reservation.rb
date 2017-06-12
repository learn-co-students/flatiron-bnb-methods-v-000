class Reservation < ActiveRecord::Base

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validates :checkin, :checkout, uniqueness: true
  validate :checkin_checkout, :available

  def duration
  	(self.checkout - self.checkin).to_i
  end

  def total_price
  	self.duration*self.listing.price
  end

  private

  def checkin_checkout
    if (self.checkout && self.checkin) && (self.checkout <= self.checkin) 
      errors.add(:guest_id, "Check in must be before check out")
    end  
  end

  def available
    if self.status == "pending"
      errors.add(:checkin, "Unavailable")
    end 
  end
end
