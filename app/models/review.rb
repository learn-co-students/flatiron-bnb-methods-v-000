class Review < ActiveRecord::Base
  
  validates :rating, :description, presence: true
  validate :is_valid
  
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  def is_valid
  	if !self.reservation_id.nil?
	  	unless self.reservation.status == "accepted" && self.reservation.checkout.past?
	  		self.errors[:reservation] << "bad"
	  	end
	  else
	  		self.errors[:reservation] << "no res"
	end
  end

end
