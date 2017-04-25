class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true

  validate :reservation_accepted, :after_checkout

  def reservation_accepted
    if reservation.try(:status) != "accepted"
      errors.add(:reservation, "Cannot leave review if reservation has not yet been accepted")
    end
  end

  def after_checkout
    if reservation && Date.today < reservation.checkout
      errors.add(:reservation, "Cannot add review until after checkout")
    end
  end

end
