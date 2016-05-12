class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :valid_review

  private

  def valid_review
    unless (Reservation.exists?(reservation_id) && Reservation.find(reservation_id).status == 'accepted' && Reservation.find(reservation_id).checkout < Date.today)
      errors.add(:reservation_id, "Reservation doesn't exist.")
    end
  end

end
