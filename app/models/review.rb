class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :reservation_exists

  def reservation_exists
    if !reservation_id || reservation.status != "accepted" || reservation.checkout > Date.today
      errors.add(:reservation_id, "Review is not associated with a valid reservation.")
    end
  end

end
