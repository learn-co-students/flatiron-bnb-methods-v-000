class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true

  validate :valid_reservation_review

  private
  def valid_reservation_review
    if self.reservation
      if self.reservation.status != 'accepted'
        errors.add(:reservation_id, "Your reservation must have been accepted")
      elsif Date.parse(self.reservation.checkout.to_s) - Date.today >= 0
        errors.add(:reservation_id, "Unable to create review for listing you have not stayed at")
      end
    else
      errors.add(:reservation_id, "Must have had a reservation to review a listing")
    end
  end

end
