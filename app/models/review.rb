class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :only_valid_if

  def only_valid_if 
    if !(self.reservation && self.reservation.status = "accepted" && self.reservation.checkout < Date.today)
      errors.add(:review, "can't be done during existing reservation, without a reservation, or without an accepted reservation")
    end 
  end 
  
end
