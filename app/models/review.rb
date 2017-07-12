class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true
  validate :checked_out, :should_be_created_on_finished_reservation

  private

    def checked_out
      if reservation && reservation.checkout > Date.today
        self.errors.add(:guest_id, "Reservation must be checked out!")
      end
    end

    def should_be_created_on_finished_reservation
      if self.reservation && self.reservation.status != "accepted"
        self.errors.add(:guest_id, "Reservation must be accepted!")
      end
    end
end
