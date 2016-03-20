class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description, :reservation
  validate :guest_checked_out
  
  def guest_checked_out
    if self.reservation && self.created_at 
      if self.reservation.checkout >= self.created_at
        errors.add(:guest_checked_out, "must be checkout out to review")
      end
    end
  end

end
