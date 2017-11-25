class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :description, :rating, :reservation, presence: true
  validate :reservation_has_happened

  private

  def reservation_has_happened
    unless reservation && reservation.checkout <= Date.today
      errors.add(:reservation, "Resrvation is not complete.")
    end
  end

end
