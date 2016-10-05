class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :reserve_own_listing, :listing_available, :dates_valid

  def reserve_own_listing
  	if listing_id == guest_id
  		errors.add(:guest, "You can't make a reservation for your own listing")
  	end
  end

  def listing_available
  	other_reservations = listing.reservations.delete(self)
  	other_reservations.each do |reservation|
  		if (checkin..checkout).overlaps?(reservation.checkin..reservation.checkout)
  			errors.add(:checkin, :checkout,  "Date is not available")
  		end
  	end
  end

  def :dates_valid
  	if checkin > checkout
  		errors.add(:checkin, :checkout, "Checkin must be before checkout")
  	elsif checkin == checkout
  		errors.add(:checkin, :checkout, "Can't check in and check out the same day")
  	end
  end

  def duration
  	self.checkout - self.checkin
  end

  def total_price
  	self.duration * self.price
  end


end
