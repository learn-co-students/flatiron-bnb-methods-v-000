class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating, :reservation_id
  validate :trip_happened

  def trip_happened
    if reservation.nil? || reservation.status != "accepted" || reservation.checkout > Date.today
      errors.add(:reservation, "Review can only be left on a valid reservation that has already been completed.")
    end
  end

end
