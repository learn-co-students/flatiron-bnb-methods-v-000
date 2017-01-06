class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, :reservation, presence: true
  validate :reservation_valid

  private

  def reservation_valid
    if self.reservation.status != "accepted"
      errors.add(:reservation, "reservation not accepted")
    end
  end

end
