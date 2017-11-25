class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validates :rating, numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 5,
              only_integer: true
            }
  validate :reservation_ended, :reservation_accepted

  private

    def reservation_ended
      if reservation &&
        Date.today < reservation.checkout
        errors.add(:reservation, "Reservation must be completed before you can leave a review.")
      end
    end

    def reservation_accepted
      if reservation.try(:status) != 'accepted'
        errors.add(:reservation, "Reservation must be accpeted before you can leave a review.")
      end
    end

end
