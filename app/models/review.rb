class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true 
  validate :this_review

private

  def this_review
    if !( !!self.reservation && self.reservation.status == "accepted" && Date.today > self.reservation.checkout )
      errors.add(:user_id, "You must have a reservation to write a review.")
    end
  end





end ## class end 
