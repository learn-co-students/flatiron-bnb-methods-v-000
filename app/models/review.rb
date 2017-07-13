class Review < ActiveRecord::Base
  validates :rating, :description, presence: true
  validate :is_valid

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  private
    def is_valid
      if !reservation
        errors.add(:reservation_id, "must have reservation")
      else
        if reservation.status != "accepted"
          errors.add(:is_valid, "reservation is not accepted")
        end

        if reservation.checkout > Date.today
          errors.add(:is_valid, "checkout has not happened")
        end
      end
    end

end
