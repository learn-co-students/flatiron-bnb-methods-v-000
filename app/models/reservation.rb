class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates_presence_of :checkin, :checkout, :listing
  validate :invalid_reservation, :listing_available?, :checkin_checkout 
   
   def invalid_reservation
      if guest_id == listing.host_id
       errors.add(:guest, "You can't make a reservation on your listing")
      end
   end
    
    def listing_available?
       Reservation.where(listing_id: listing_id).where.not(id: id).each do |r|
       
        if (r.checkin..r.checkout) === checkin || (r.checkin..r.checkout) === checkout
        errors.add(:listing, "There is no listing")
        
       end
      end
    end

    def checkin_checkout
     if checkin && checkout && listing
      if checkin >= checkout
      errors.add(:checkin, "Checkin must be before checkout")
      end
     end
    end
    
    def duration
      (checkout - checkin)
    end

    def total_price
      self.duration * listing.price
    end
    
end
