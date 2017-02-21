class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_many :joins
  
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :no_self_reservation
  validate :available
  validate :sensical_times
  

  def no_self_reservation
  	if listing.host.id == guest_id
  		errors.add(:name, "You cannot make a reservation on your own listing")
  	end
  end

  # need to check reservation.listing.reservations for any reservations that conflict

  def available
  	if listing.reservations && checkin && checkout
  		listing.reservations.each do |reservation|
  			if checkin.between?(reservation.checkin, reservation.checkout) || checkout.between?(reservation.checkin, reservation.checkout)
  				errors.add(:checkin, "No good")
  			end
  		end
  	end
  end

  def sensical_times
  	if checkin && checkout
  		if checkout <= checkin
  			errors.add(:checkin, "Wrong")
  		end
  	end
  end

  def duration
  	checkout - checkin
  end

  def total_price
  	listing.price.to_f * duration
  end

end
