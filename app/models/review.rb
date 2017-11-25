class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating
  validates_presence_of :description
  validates_presence_of :reservation
  validate :checkout_has_happend

  def checkout_has_happend
    if res = Reservation.find_by(id: reservation_id)
      if Date.today < res.checkout
        errors.add(:checkout, "You can't send a review yet, you haven't checked out yet!")
      end
    end
  end
end
