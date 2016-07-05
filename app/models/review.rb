class Review < ActiveRecord::Base
  validates :rating, presence: true
  validates :description, presence: true
  validate :check_reservation

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  def check_reservation
    if !self.reservation || self.reservation.status != "accepted" || Date.today < self.reservation.checkout
      errors.add(:reservation, "invalid")
    end
  end


end
