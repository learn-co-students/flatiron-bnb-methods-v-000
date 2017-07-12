class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :reservation_complete

  private
    def reservation_complete
      if reservation && (reservation.status != "accepted" || Date.today < reservation.checkout)
        errors.add(:description, "cannot submit review for reservation that isn't complete")
      end
    end

end
