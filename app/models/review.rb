class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: :true
  validates :description, presence: :true
  validates :reservation_id, presence: :true
  validate :valid_reservation
 
  def valid_reservation
  	if self.reservation_id == nil || self.reservation.status != "accepted" || self.reservation.checkout > DateTime.now.to_date
  		errors.add(:reservation, 'cannot leave review.')
  	end
  end
  
end
