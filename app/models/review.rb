class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :description, presence: true
  validates :rating, presence: true
  validate :accepted_res_with_checkout

  def accepted_res_with_checkout
  	if !self.reservation
  		errors.add(:reservation, "You have no reservation")
  	elsif self.reservation.status != "accepted"
   		errors.add(:reservation, "Your reservation is still pending")
   	elsif self.reservation.checkout > Date.today
   		errors.add(:reservation, "You haven't checked out yet")
   	end	
  end
end
