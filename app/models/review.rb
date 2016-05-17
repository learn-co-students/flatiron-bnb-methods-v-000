class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :checkout_has_happened

  def checkout_has_happened
    if rez = Reservation.find_by(id: reservation_id)
      if Date.today < rez.checkout
        errors.add(:checkout, "You can't send a review yet, you haven't checked out.")
      end
    end
  end
end
