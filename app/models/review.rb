# Review
class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, class_name: 'User'

  validates_presence_of :description, :rating, :reservation
  validate :checkout?

  def checkout?
    res = Reservation.find_by(id: reservation_id)
    if res
      if Date.today < res.checkout
        errors.add(:checkout, 'Plese write a review after checking out.')
      end
    end
  end
end
