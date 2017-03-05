class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :invalid_same_checkout_checkin
  validate :validate_own_listing
  validate :checkin_before_checkout
  validate :available_at_checkin?
  validate :available_at_checkout?
  
  def invalid_same_checkout_checkin
    if checkin.to_s == checkout.to_s
      errors.add(:checkin, "can't be the same as checkout")
      end 
    end 
    
    def validate_own_listing
      host = User.find_by(id: self.listing.host_id)
      guest = self.guest
      if guest == host 
        errors.add(:host, "can't be the same as guest")
      end 
    end
  
    def checkin_before_checkout
      if !(checkin.to_s < checkout.to_s)
        errors.add(:checkin, "can't be the same after checkout")
      end 
    end 

    def available_at_checkin?
      self.listing.reservations.each do |reservation|
        if !(checkin.to_s <= reservation.checkin.to_s || reservation.checkout.to_s <= checkin.to_s)
          errors.add(:checkin, "can't be during existing reservation")
        end 
      end
    end 

    def available_at_checkout?
      self.listing.reservations.each do |reservation|
        if !(checkout.to_s <= reservation.checkin.to_s || reservation.checkout.to_s <= checkout.to_s)
          errors.add(:checkout, "can't be during existing reservation")
        end 
      end
    end 

    def duration
      duration = Date.parse(checkout.to_s) - Date.parse(checkin.to_s)
      duration.to_i
    end 
    
    def total_price
      listing.price * duration
    end 
    
end
