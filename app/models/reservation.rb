class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :invalid_same_ids
  validate :invalidcheckin
  validate :invalidcheckout
  validate :same_checkout

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price.to_f * self.duration
  end


  private

  def invalid_same_ids
    if self.guest_id == self.listing_id
      errors.add(:guest_id, "cannot reserve your own listing")
    end
  end

 def invalidcheckin
   checkdate(self.checkin) && errors.add(:checkin, "invalid checkin")
 end

 def invalidcheckout
   checkdate(self.checkout) && errors.add(:checkout, "invalid checkout")
 end

 def checkdate(day)
    self.listing.reservations.each do |reservation|
      if day.nil? || day > reservation.checkin && day < reservation.checkout
        return true
      end
    end
    false
 end

 def same_checkout
   if !self.checkin.nil? && !self.checkout.nil? && self.checkout <= self.checkin
     errors.add(:checkin, "checkin cannot be the same as checkout")
   end
 end

end
