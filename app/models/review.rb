class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  # Validations
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :check_reservation

  def check_reservation
    if self.reservation
      if self.reservation.checkout > Time.now
        errors.add(:check_reservation, "This review is dated before the reservation.")
      end
    end
  end
end
