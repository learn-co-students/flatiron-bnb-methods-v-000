class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating, :reservation_id
  validate :all_validated

private
  def all_validated
  if self.reservation && self.description && self.reservation_id
    if self.reservation.status != "accepted"
      errors.add(:guest_id, "Please make a reservation first.")
    end
    if !(self.reservation.checkout < Date.today)
      errors.add(:checkout, "Choose a date before today")
    end

  end
  end

end
