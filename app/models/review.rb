class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :has_completed_reservation

  private

  def has_completed_reservation
    return nil if attrs_nil?
    if self.reservation == nil
      errors.add(:reservation, "not associated with this review")
      return nil
    end

    if self.reservation.status != "accepted"
      errors.add(:status, "is not accepted")
    end

    if self.reservation.checkout > Date.today
      errors.add(:checkout_date, "has not happened yet")
    end
  end

  # helper methods

  def attrs_nil?
    true if self.rating == nil || self.description == nil
  end
end
