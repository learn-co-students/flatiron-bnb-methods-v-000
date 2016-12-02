class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates_date :checkin, :before => :checkout
  validates :checkout, presence: true 
  validate :own_listing?, :listing_available?

 

    
  
  ##validates :status, confirmation: true, :if => Proc.new {|a| !(a.status == "pending")}

  def duration
    (self.checkout - self.checkin)
  end

  def total_price
    self.listing.price * duration
  end

  private

  def own_listing?
    if self.guest == self.listing.host
      errors.add(:guest, "You cannot make a reservation on your own listing. Please choose another.")
    end
  end


  def listing_available?
    if self.checkin && self.checkout
      if !listing.nil?
        listing.reservations.find do |current_reservations|
            if (!self.checkin.between?(current_reservations.checkin, current_reservations.checkout) && !self.checkout.between?(current_reservations.checkin, current_reservations.checkout))
              true
            else
              errors.add(:guest_id, "This listing is not available.")
            end
        end
      end
    else
      true
    end
  end

end

