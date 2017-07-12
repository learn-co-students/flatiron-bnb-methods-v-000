class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true 
  validate :no_own_listing
  validate :available_at_checkin
  validate :checkin_before_checkout_and_not_same
  # before_save :check_dates



  def no_own_listing
  	if self.listing.host_id == self.guest_id 
  	errors.add(:guest_id, 'You cannot book your own listing!') 
  	end  	
  end

  def available_at_checkin
  	start_date = self.checkin
  	end_date = self.checkout
	if start_date && end_date
		if self.listing.reservations.any? { |reservation| start_date <= reservation.checkout && end_date >= reservation.checkin }
			errors.add(:checkin, 'Please choose some other time') 
  		end 
  	end 
  end

  def checkin_before_checkout_and_not_same
  	if self.checkin && self.checkout
	  	if self.checkin >= self.checkout
	  		errors.add(:checkin, 'Please choose checkin before checkout') 
	  	end 
  	end
  end

  def duration
  	self.checkout - self.checkin	
  end

  def total_price
  	self.duration * self.listing.price
  	
  end

end
