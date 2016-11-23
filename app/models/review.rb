class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :reservation, presence: true
  validates :rating, presence: true, numericality: {
            greater_than_or_equal_to: 0,
            less_than_or_equal_to: 5,
            only_integer: true
          }
  validate :pass_checkout, :accepted

  private

  def accepted
    if reservation.try(:status) != "accepted"
      errors.add(:status, "Reservation is not been accepted")
    end
  end

  def pass_checkout
    if reservation != nil
      if reservation.checkout  > Date.today
        errors.add(:reservation, "Cannot make a review until after checked out.")
      end
    end
  end
end
