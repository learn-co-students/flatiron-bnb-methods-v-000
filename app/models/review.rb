class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating
  validates_presence_of :description
  validates_presence_of :reservation
  validate :checkout_has_happened


  private

  def checkout_has_happened
    if res = Reservation.find_by(id: reservation_id)
      if res.status == "accepted"
        if Date.today < res.checkout
          errors.add(:checkout, "You can't submit a review, you haven't completed your stay yet!")
        end
      end
    end
  end

end
