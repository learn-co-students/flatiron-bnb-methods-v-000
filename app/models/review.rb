class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validate :reservation_checks_out

  def reservation_checks_out
    if !reservation
      errors.add(:guest_id, "sorry, this review can't be posted yet")
    elsif reservation.status != "accepted"
      errors.add(:guest_id, "sorry, this review can't be posted yet")
    elsif !updated_at.nil?
      if updated_at <= reservation.checkout
        errors.add(:guest_id, "sorry, this review can't be posted yet")
      end
    end
  end
end
