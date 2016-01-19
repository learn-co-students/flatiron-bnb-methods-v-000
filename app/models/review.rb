class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :has_reservation

  private

  def has_reservation
    if self.reservation && !(Date.today > self.reservation.checkout)
      errors.add(:review_error, "You need a reservation to leave a review.")
    end
  end


end
