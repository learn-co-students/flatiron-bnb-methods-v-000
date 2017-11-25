require 'pry'
class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true
  validate :reservation_is_passed

  def reservation_is_passed
    if self.reservation && self.reservation.checkout > Date.today
      errors.add(:reservation, "reservation must be in the past")
    end
  end
end
