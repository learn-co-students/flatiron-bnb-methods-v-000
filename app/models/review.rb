class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true
  validate :accepted, :checked_out

  private

  def accepted
  	if reservation && !reservation.status == "accepted"
  		errors.add(:reservation_id, "Reservation must be accepted to write a review")
  	end
  end

  def checked_out
  	if reservation && reservation.checkout > Time.new
  		errors.add(:reservation_id, "Must be checked out to write a review")
  	end
  end

end
