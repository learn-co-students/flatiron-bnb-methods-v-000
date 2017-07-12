class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :reservation, :rating, presence: true #works without rating val

  validate :checkout_happened? #order; before acceptance_status
  validate :acceptance_status

  def acceptance_status
    errors.add(:review, "is not valid") if reservation.try(:status) != 'accepted'
  end

  def checkout_happened?
    errors.add(:review, "is not valid") if reservation && reservation.checkout > Date.today
  end
end
