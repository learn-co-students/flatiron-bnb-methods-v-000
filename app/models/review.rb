class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :description, :rating, :reservation
  validate :accepted
  validate :date_not_passed

  def accepted
    if reservation && reservation.status != "accepted"
      errors.add(:reservation, "Reservation must be accepted")
    end
  end

  def date_not_passed
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reservation must over")
    end
  end
end
