class Review < ActiveRecord::Base

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :reservation_accepted

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  def reservation_accepted
  	if !(reservation && self.reservation.status=='accepted' && Date.today > self.reservation.checkout) 
  		errors.add(:rating, "You can't leave a review(yet)")
  	end
  end

end
