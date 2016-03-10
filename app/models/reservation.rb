class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  
  has_one :review

  validates :checkin, :checkout, presence: true
  

  validate :host_and_guest_cannot_be_the_same,
           :listing_available_at_checkin,
           :listing_available_at_checkout,
           :checkin_is_before_checkout

  def host_and_guest_cannot_be_the_same	
      if listing && listing.host_id == guest_id 
	  		errors.add(:guest_id, "Host and guest cannot be the same person.")
	  	end
  end

  def listing_available_at_checkin
    if checkin && listing.reservations && listing.reservations.any? {|r| checkin >=r.checkin && checkin <= r.checkout }
      errors.add(:checkin, "Listing no available at checkin")
    end
  end

  def listing_available_at_checkout
    if checkout && listing.reservations && listing.reservations.any? {|r| checkout >=r.checkin && checkout <= r.checkout }
      errors.add(:checkin, "Listing no available at checkin")
    end
  end

  def checkin_is_before_checkout
    if checkin && checkout && checkin >= checkout
      errors.add(:checkin, "Checkin must be before checkout.")
    end
  end

  def duration
   (checkout - checkin).numerator
  end

  def total_price
    listing.price * duration
  end
  






end
