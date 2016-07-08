class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true

  validate :reservation_has_been_accepted_and_checkout_has_happened


  def reservation_has_been_accepted_and_checkout_has_happened
    if reservation == nil || reservation.status != "accepted" || Date.today < reservation.checkout
      errors.add(:guest_id)
    end
  end

end
