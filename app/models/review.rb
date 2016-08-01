class Review < ActiveRecord::Base
  belongs_to :reservation, required: true
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, presence: true, numericality: {
            greater_than_or_equal_to: 0,
            less_than_or_equal_to: 5,
            only_integer: true
          }
  validates :reservation, presence: true
  # validates :review_after_checkout

  private
    def review_after_checkout
      if reservation && reservation.checkout > Date.today
        errors.add(:reservation, "You must be checked out to submit a review.")
      end
    end


end
