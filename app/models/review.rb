class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
 

  validates_presence_of :rating, :description, :reservation
  validate :checked_out
  
  private

    def checked_out
      if reservation && reservation.checkout > Date.today
        errors.add(:reservation, "You must checkout before leaving a review.")
      end
    end 
end 