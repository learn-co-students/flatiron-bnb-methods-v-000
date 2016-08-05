class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :valid_review

  def valid_review
    if !reservation || reservation.checkout > Date.today || reservation.status != "accepted"
    errors.add(:reservation, "You are unable to leave a review at this time.")
    end 
  end

end
