class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true 
  validates :reservation, presence: true
  validate :status 
  validate :checkout_happened


  def status
  	if self.reservation
	  if self.reservation.status != "accepted"
	  	errors.add(:status, 'You have to be accepted first!') 
	  end 
	end 
  end

  def checkout_happened
	  	if self.reservation
		  	if self.reservation.checkout > Date.today
		  		errors.add(:status, 'You have to checkout first!') 
		    end
		end 
    end 
end
