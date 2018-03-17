class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :checkout_has_happened

  private

  def checkout_has_happened
    if reservation && reservation.checkout && (Date.today-reservation.checkout).numerator <= 0
      errors.add(:guest_id, "checkout has not yet happened")
    end
  end
end
