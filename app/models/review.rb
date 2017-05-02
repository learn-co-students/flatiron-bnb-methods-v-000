class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, presence: true
  validate :reservation_is_valid

  def reservation_is_valid
  	if !self.reservation
  		errors.add(:reservation_is_valid, "Must be associated to reservation")
  	elsif !status_accepted
  		errors.add(:reservation_is_valid, "Reservation must have been accepted")
  	elsif !checkout_happend
  		errors.add(:reservation_is_valid, "Please wait until you have checked out to leave a review")  		
  	end
  end

  def status_accepted
  	self.reservation.status == "accepted"
  end

  def checkout_happend
  	self.reservation.checkout < Date.today
  end
end
