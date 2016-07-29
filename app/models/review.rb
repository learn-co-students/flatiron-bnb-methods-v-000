class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true

  validate :can_leave_review

  private

  def can_leave_review
  	if !reservation || reservation.checkout > Date.today 
  		errors.add(:review, "You are unable to leave a review without a reservation")
  	end
  end

end
