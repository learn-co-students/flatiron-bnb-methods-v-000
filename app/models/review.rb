class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description
  validate :assoc_reservation, :reservation_accepted, :checked_out

  def assoc_reservation
    errors.add(:review, "not tied to a reservation.")  if self.reservation.nil?
  end

  def reservation_accepted
    errors.add(:review, "not tied to accepted reservation.") if self.reservation.try(:status) != "accepted"
  end

  def checked_out
    errors.add(:review, "cannot be added prior to checkout.") if self.reservation.try(:checkout) &&  self.reservation.try(:checkout) > Time.now
  end
end
