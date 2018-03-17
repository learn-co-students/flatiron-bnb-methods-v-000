class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :reservation_has_been_accepted, :checkout_has_happened

  private

  def reservation_has_been_accepted
    if self.reservation && !self.reservation.status == "accepted"
      errors.add(:reservation, "reservation has not yet been accepted")
    end
  end

  def checkout_has_happened
    if self.reservation && !(Date.today > self.reservation.checkout)
      errors.add(:reservation, "checkout has not yet happened")
    end
  end

end