class Review < ActiveRecord::Base
  ## See solution for cleaner and more descriptive methods :)

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating
  validates_presence_of :description
  validates_presence_of :reservation
  validate :checked_out


  private

  def checked_out
    if res = Reservation.find_by(id: reservation_id)
      if res.status == "accepted"
        if Date.today < res.checkout
          errors.add(:checkout, "You can't submit a review, you haven't completed your stay yet!")
        end
      end
    end
  end

end
