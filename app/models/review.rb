

class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :has_reservation
  
  private
  
   def has_reservation	
    	if !reservation || reservation.status != "accepted" || reservation.checkout >= Date.today
	    	errors[:reservation] << "You need a proper reservation to proceed"
	    end
   end

end
