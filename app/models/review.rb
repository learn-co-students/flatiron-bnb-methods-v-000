class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true

  validate :reservation_accepted
  validate :checkout_passed

  private

    def reservation_accepted
      unless reservation && reservation.status == "accepted"
        errors.add(:reservation_status, "must be accepted")
      end
    end

    def checkout_passed
      unless reservation && reservation.checked_out?
        errors.add(:reservation, "must be checked-out already")
      end
    end

end
