class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, :reservation, presence: true
  validate :reservation_been_accepted, :checkout_happened

  def reservation_been_accepted
    if reservation && reservation.status != "accepted"
      errors.add(:reservation, "must have been accepted.")
    end
  end

  def checkout_happened
    if reservation && (reservation.checkout >= Date.today)
      errors.add(:checkout, "must have happened.")
    end
  end

end
