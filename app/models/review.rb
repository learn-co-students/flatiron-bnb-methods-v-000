class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :trip_completed

  def trip_completed
    if reservation && (reservation.status != "accepted" || reservation.checkout > Date.today)
      errors.add(:rating, "Please wait until after your trip is completed to post a review")
    end
  end

end
