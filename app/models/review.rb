class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :accepted_and_checked_out

  private

  def accepted_and_checked_out
      if reservation == nil || reservation.status != "accepted" || reservation.checkout > Date.today
        errors.add(:invalid_review, "You need to have a reservation and checked out to leave a review.")
      end
  end

end
