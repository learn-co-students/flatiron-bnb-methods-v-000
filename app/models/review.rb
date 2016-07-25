class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :valid_review

  def valid_review
    if rating && description && (reservation_id.nil? || reservation.status != "accepted" || Date.today < reservation.checkout)
      errors.add(:guest_id, "")
    end
  end

end
