class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :trip_occured?

  def trip_occured?
    if !reservation.nil? && reservation.status == "accepted" && reservation.checkout < Date.today
      true
    else
      errors.add(:trip_occured?, "Please wait until the end of the trip to write a review.")
    end
  end
end
