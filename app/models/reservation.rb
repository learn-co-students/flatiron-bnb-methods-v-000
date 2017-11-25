class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: :true
  validate :is_after_or_equal
  validate :checkin_not_taken
  validate :if_not_user
  


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
    if self.checkin == nil
      errors.add(:checkin, "Checkin cannot be blank")
    elsif self.checkout == nil
      errors.add(:checkout, "Checkout cannot be blank")
    elsif self.checkin > self.checkout
      errors.add(:checkin, "Cannot be after checkout date")
    elsif self.checkin == self.checkout
      errors.add(:checkin, "Checkin must be before checkout")
    end

  end

  def checkin_not_taken
    if self.checkin == nil
      errors.add(:checkin, "Checkin cannot be blank")
    elsif self.checkout == nil
      errors.add(:checkout, "Checkout cannot be blank")
    else

     Reservation.where(listing_id: self.listing_id ).each do |x|
      if x.id != self.id
        start = x.checkin
        last = x.checkout
       
        if self.checkin.between?(start,last) || self.checkout.between?(start,last)

      
          errors.add(:checkin, "That listing is currently booked during that time.")
        end
    end
  end
  end
    end

  
end
