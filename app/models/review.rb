class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true 
  validates :description, presence: true 
  validates :reservation_id, presence: true
  validate :accepted_and_checked_out

  def accepted_and_checked_out
    if reservation == nil || reservation.status != "accepted" || reservation.checkout > Date.today
      errors.add(:accepted_and_checked_out, "Sorry, invalid entry.")
    end 
  end 
  


end
