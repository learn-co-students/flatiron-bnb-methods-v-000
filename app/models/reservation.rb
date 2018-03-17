class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  
  validates :checkin, :checkout, presence: true
  validate :not_same_as_host, :listing_available, :checkin_is_first
  
  
  def duration
    (self.checkout - self.checkin).to_i
  end
  
  def total_price
    listing.price * self.duration
  end
  
  
  private
  
    def not_same_as_host
      if guest_id == listing.host_id
        errors.add(:guest_id, "can't be the same as host")
      end
    end

    def listing_available
      listing.reservations.each do |r|
        range = r.checkin..r.checkout
        if range === self.checkin || range === self.checkout
          errors.add(:guest_id, "date is unavailable")
        end
      end
    end
    
    def checkin_is_first
      if checkin && checkout
        if checkout <= checkin
          errors.add(:guest_id, "checkout date must be after checkin")
        end
      end
    end
    
end