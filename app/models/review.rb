class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validate :is_reviewable

  def is_reviewable
    errors.add(:reservation_id, "doesn't exist") unless Reservation.exists?(reservation_id) && Reservation.find(reservation_id).status == "accepted" && Reservation.find(reservation_id).checkout < Date.today
  end

end
