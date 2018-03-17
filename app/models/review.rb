class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true

  validate :been_accepted?
  validate :checkout_happened?

  private

  def been_accepted?
    unless reservation.nil?
      if reservation.status != "accepted"
        errors.add(:reservation, "Reservation must be accepted to leave a review")
      end
    end
  end

  def checkout_happened?
    unless reservation.nil?
      if Date.today < reservation.checkout
        errors.add(:reservation, "Cannot leave a review unless the reservation has passed")
      end
    end
  end
end
