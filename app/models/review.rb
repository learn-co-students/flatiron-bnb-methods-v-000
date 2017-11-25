class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  #validates :rating, :description, :reservation_id, presence: :true  
  validate :review_check

  def review_check
    if self.rating == nil
      errors.add(:rating, "Review needs a rating.")
    elsif self.description == nil
      errors.add(:description, "Needs description")
    elsif self.reservation_id == nil
      errors.add(:reservation_id, "Needs a reservation")
    elsif Reservation.find(self.reservation_id).checkout > Date.today   
      errors.add(:id, "Reservation has not finished yet")
    elsif !Reservation.find(self.reservation_id)     
      errors.add(:reservation_id, "Reservation does not exist.")
    elsif Reservation.find(self.reservation_id).status != "accepted"    
       errors.add(:reservation_id, "Reservation has not been accepted yet")
    end
  end

  


end
