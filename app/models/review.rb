class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true

  validate :checkout_has_passed


  def checkout_has_passed
  	if self.reservation_id && self.reservation.checkout > Date.today
  		errors.add(:checkout, "checkout date has not passed")
  	end
  end


end
