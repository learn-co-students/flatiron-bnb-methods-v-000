class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :has_associated_reservation

  private
  def has_associated_reservation
    if reservation
    if reservation.status != "accepted" || reservation.checkout > Date.today
      errors.add(:reservation_id, "doesn't exist")
    end
    end

  end

end
