class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true 
  validates :checkout, presence: true 
  validate :own_listing
  validate :checkin_date
  validate :checkout_date 
  validate :checkin_before_checkout
  

  def own_listing 
    errors.add(:own_listing, "can't be guest at own listing") if listing.host == guest 
  end 

  def checkin_date 
    if checkin != nil 
      listing.reservations.each do |r| 
        if self.checkin >= r.checkin &&  self.checkin <= r.checkout
          errors.add(:checkin_date, "Listing not available on checkin date.")
        end 
      end 
    end 
  end 


  def checkout_date 
    if checkout != nil 
      listing.reservations.each do |r| 
        if self.checkout <= r.checkout && self.checkout >= r.checkin
          errors.add(:checkout_date, "Checkout date not available.")
        end 
      end 
    end 
  end 

  def checkin_before_checkout 
    if checkin != nil && checkout != nil 
      if checkin >= checkout 
        errors.add(:checkin_before_checkout, "You must set a checkin date before a checkout date.")
      end 
    end 
    
  end 

  def duration 
    (checkout-checkin)
  end 
  
  def total_price 
    duration * listing.price 
  end 
  
  
  
  

  


end
