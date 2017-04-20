class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :reservation_is_valid


  private

  def reservation_is_valid
    if reservation == nil || reservation.status != "accepted" || reservation.checkout > Date.today
      errors.add(:reservation, "must be a valid, accepted reservation.")
    end
  end

end
