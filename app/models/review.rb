class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5}

  validates :reservation, presence: true

  validate :reservation_accepted, :checkout_occured

  # review validations is invalid without an associated reservation, 
  # has been accepted, and 
  # checkout has happened
  private

  def reservation_accepted
    if reservation.try(:status) != "accepted"
      errors.add(:reservation, "reservation must be accepted to review")
    end
  end

  def checkout_occured
    if reservation && reservation.checkout > Date.today 
      errors.add(:reservation, "check-out must be complete to review")
    end
  end

end
