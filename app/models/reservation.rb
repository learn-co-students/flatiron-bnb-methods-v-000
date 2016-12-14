class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  

  validates_presence_of :checkin, :checkout
  validate :host_not_guest, :checkin_before_checkout, :available?






  def host_not_guest
      if self.listing.host_id == self.guest_id
      errors.add(:host_not_guest, "You cannot make a reservation on your own listing")
    end
  end


  def checkin_before_checkout
    if checkin && checkout && checkout <= checkin
      errors.add(:reservation, "Please try again.")
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price 
  end




  def available?
    if checkin && checkout
      listing.reservations.each do |res|
        if res.checkin <= checkout && res.checkout >= checkin
          errors.add(:reservation, "Please try again.")
        end
      end
    end
  end


end


    
    
    # validates that a listing is available at checkout before making reservation (FAILED - 18)
    # validates that a listing is available at for both checkin and checkout before making reservation (FAILED - 19)
    # validates that checkin is before checkout (FAILED - 20)
    # validates that checkin and checkout dates are not the same (FAILED - 21)
