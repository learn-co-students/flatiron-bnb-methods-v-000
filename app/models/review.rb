class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true

  validate :accepted_reservation

  private

  def accepted_reservation
    #binding.pry
    unless self.reservation && self.reservation.status == "accepted" && self.reservation.checkout < Date.today
      errors.add(:reservation_id, "Reservation not finalized")
    end
  end
end
