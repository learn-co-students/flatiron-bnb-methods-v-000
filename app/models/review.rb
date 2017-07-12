class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation_id
  validate :checked_out?

  def checked_out?
    if reservation
     if self.reservation.checkout > Date.today || self.reservation.status != "accepted"
       errors.add(:checkout, "Please, try again.")
     end
    end
  end

end
