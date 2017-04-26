class Review < ActiveRecord::Base
  # validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true

  validate :checkout_happened? #order; before acceptance_status
  validate :acceptance_status
  # validates :checkout, numericality: {less_than_or_equal_to: Time.now}
  #validates :release_year, numericality: { only_integer: true, less_than_or_equal_to: Time.now.year, if: :released }

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  def acceptance_status
    if reservation.try(:status) != 'accepted'
      errors.add(:review, "is not valid")
    end
  end

  def checkout_happened?
    #binding.pry
    errors.add(:review, "is not valid") if reservation && reservation.checkout > Date.today
  end
end
