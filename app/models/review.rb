class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, :reservation, presence: true
  validate :stay_completed

  private
    def stay_completed
      if reservation && reservation.checkout > Date.today
        errors.add(:reservation, "You must be checked out to submit a review.")
      end
    end

end
