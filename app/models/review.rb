class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true

  validate :checkout, :valid_review


  def checkout
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Checkout error")
    end
  end

  def valid_review

    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Checkout error")
    end

  end


end
