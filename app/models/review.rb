class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :valid_reservation

  protected
  def valid_reservation
    if id == 4
      binding.pry
    end
    if !reservation || !(reservation.status == "accepted") || (reservation && reservation.checkout > Date.today)
      errors.add(:reservation, "should be valid")
    end
  end

end
