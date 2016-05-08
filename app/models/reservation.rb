class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_and_host_different
  validate :res_does_not_conflict
  validate :checkout_after_checkin, :unless => "checkin.nil? || checkout.nil?"

  def guest_and_host_different
  	if self.guest == self.listing.host 
  		errors.add(:guest, "Guest and Host must be different")
  	end
  end

  def res_does_not_conflict
  	Reservation.all.each do |res|
  		if res.id != self.id
  			if (res.checkin...res.checkout-1.days).include?(self.checkin)
  				errors.add(:checkin, "Your check-in conflicts with another")
  			elsif (res.checkin+1.days..res.checkout).include?(self.checkout)
  				errors.add(:checkout, "Your check-out conflicts with another")		
  			end
  		end
  	end
  end

  def checkout_after_checkin
  	if self.checkout <= self.checkin 
  		errors.add(:checkout, "Your check-out must be after your check-in")
  	end
  end

  def duration
  	(self.checkout - self.checkin).to_i 
  end

  def total_price
  	days = (self.checkout - self.checkin).to_i
	days * self.listing.price 
  end


end
