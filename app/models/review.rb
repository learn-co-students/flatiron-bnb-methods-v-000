class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  validate :good_review

  def good_review
  	if !self.reservation || self.reservation.status != "accepted" || self.reservation.checkout > Date.today
  		errors.add(:rating, "no")
  	end
  end

end
