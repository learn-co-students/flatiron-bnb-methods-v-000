class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation_id

  validate :must_have_reservation


  private

  def must_have_reservation
    if !( !!self.reservation && self.reservation.status == "accepted" && Date.today > self.reservation.checkout )
      errors.add(:user_id, "You must have a reservation to leave a review.")
    end
  end

end
