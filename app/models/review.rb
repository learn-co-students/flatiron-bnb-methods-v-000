class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true

  validate :reservation_accepted
  validate :reservation_passed

  private
  def reservation_accepted
    unless reservation && reservation.status == "accepted"
      errors.add(:reservation, "must be accepted to write review")
    end
  end

  def reservation_passed
    unless reservation && reservation.passed?
      errors.add(:reservation, "must be completed to write review")
    end
  end
end
