class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true 
  validates :description, presence: true 
  validate :after_trip_completed

  private

    def after_trip_completed
    if !self.reservation || self.reservation.status == "pending" || self.reservation.checkout > Date.today
      errors.add(:review, "cannot happen until reservation is completed.")
    end
  end

end
