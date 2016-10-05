class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validate :checkout_past, :reservation_accepted

  def checkout_past
  	if !reservation.checkout.past?
  		errors.add(:reservation, "Checkout must have occured")
  	end
  end

  def reservation_accepted
  	if !reservation.status == "accepted"
  		errors.add(:reservation, "Reservation must have accepted status")
  	end
  end
  

end
