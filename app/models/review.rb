class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true
  validate :reservation_valid?


  private
  def reservation_valid?
    if !Reservation.exists?(self.reservation_id) || self.reservation.status != "accepted" || self.reservation.checkout > Date.today
      errors.add(:reservation_id, "Can't write a review for a nonexistant reservation.")
    end
  end
end
