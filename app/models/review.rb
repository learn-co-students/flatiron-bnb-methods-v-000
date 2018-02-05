class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :valid_review?

  def valid_review?
  	if !reservation || reservation.status != "accepted" || Date.today <= reservation.checkout
  		errors.add(:review, "Unable to write a view for this reservation at this time.")
  	end
  end
end
