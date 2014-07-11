class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating, :reservation_id

  validate :reservation_exists

  private
  #You can't write a review on a reservation that doesn't exist
  def reservation_exists
    errors.add(:reservation_id, "doesn't exist") unless Reservation.exists?(reservation_id)
  end
end
