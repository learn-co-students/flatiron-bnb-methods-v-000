class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validate :if_not_user
  validate :is_after_or_equal
  validates :checkin, :checkout, presence: true
  validate :checkin_not_taken


  def if_not_user
    
    if  Listing.find(self.listing_id).host_id == self.guest_id
        errors.add(:guest_id, "You cannot book reservation on your own property")
      end

  end

  def duration
    Date.parse(self.checkout.to_s)- Date.parse(self.checkin.to_s)
 
  end

  def total_price
    Listing.find(self.listing_id).price * self.duration
  end

  def is_after_or_equal
  
    if self.checkin > self.checkout
      errors.add(:checkin, "Cannot be after checkout date")
    elsif self.checkin == self.checkout
      errors.add(:checkin, "Checkin must be before checkout")
    end

  end

  def checkin_not_taken
    reservations = Reservation.where(listing_id: self.listing_id )
    reservations.each do |x|
      start = x.checkin
      last = x.checkout
     
      if self.checkin.between?(start,last) || self.checkout.between?(start,last)
    
        errors.add(:checkin, "That listing is currently booked during that time.")
      end
    end
    end

  
end
