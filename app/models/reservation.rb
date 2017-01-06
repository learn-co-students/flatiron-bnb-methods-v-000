class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :invalid_same_ids
  validate :invalidcheckin
  validate :invalidcheckout


  private

  def invalid_same_ids
    if self.guest_id == self.listing_id
      errors.add(:guest_id, "cannot reserve your own listing")
    end
  end

 def invalidcheckin
   self.listing.reservations.each do |reservation|
     if self.checkin > reservation.checkin && self.checkin < reservation.checkout
       errors.add(:checkin, "invalid checkin")
     end
   end
 end

 def invalidcheckout
   self.listing.reservations.each do |reservation|
     if self.checkout > reservation.checkin && self.checkout < reservation.checkout
       errors.add(:checkout, "invalid checkout")
     end
   end
 end

end
