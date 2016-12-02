class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description
  validates_presence_of :reservation
  validate :checked_out

  def checked_out
    if self.reservation && self.created_at && 
      self.reservation.checkout >= self.created_at
      errors.add(:revew, "Must be checked out to write a review.")
    end
  end 

end
