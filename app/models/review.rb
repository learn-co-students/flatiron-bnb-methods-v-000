class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating, :reservation
  validate :after_reservation

  def after_reservation
    if !(self.reservation && Date.today > self.reservation.checkout && self.reservation.status == 'accepted')
      errors.add(:user_id, "You must leave review after checkout.")
    end
  end

end
