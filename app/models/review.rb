class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

    validates_presence_of :rating, :description
    validate :accepted_and_checkedout

  private
    def accepted_and_checkedout
    if self.rating && self.description
      if self.reservation.nil?
        errors.add(:review, "reservation does not exit")  
      elsif self.reservation.status != "accepted"
        errors.add(:reservation, "reservation has not been accepted")
      elsif self.reservation.checkout > Date.today
        errors.add(:reservation, "cannot review until checkedout") 
      end 
    end
  end

end
