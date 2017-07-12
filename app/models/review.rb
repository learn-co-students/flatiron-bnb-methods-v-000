class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true

  validate do
    reservation_accepted
    checkout_has_happened
  end


  private

  def reservation_accepted
    self.errors.add(:base, "Reservation must be accepted.") if self.reservation && self.reservation == "accepted"
  end

  def checkout_has_happened
    self.errors.add(:base, "Must already be checked out.") if self.reservation && self.reservation.checkout >= Date.today
  end

end
