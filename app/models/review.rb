class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :reservation_was_accepted_and_happened

  private
    def reservation_was_accepted_and_happened
      unless !reservation.nil? && reservation.status == "accepted" && reservation.checkout.to_date < Date.today
        errors.add(:reservation_id, "the associated reservation must exist, have been accepted, and must be in the past")
      end
    end

end
