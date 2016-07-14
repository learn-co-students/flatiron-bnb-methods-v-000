class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :description, :rating, :reservation
  validate :checkout?

  def checkout?
    if r = Reservation.find_by(id: reservation_id)
      if Date.today < r.checkout
        errors.add(:checkout, "You must be checked out to write a review!")
      end
    end
  end
end
