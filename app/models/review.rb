class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :checked_out

  def checked_out
    if reserved = Reservation.find_by(id: reservation_id)
       if Date.today < reserved.checkout
        errors.add(:checkout, "You can't send a review until you have checked out.")
      end
    end
  end

end
