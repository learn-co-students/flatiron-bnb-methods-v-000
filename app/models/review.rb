class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  validates :reservation, presence: true
  validate :reservation_exists_and_not_accepted

  private
  def reservation_exists_and_not_accepted
    errors.add(:reservation, "not valid") unless reservation && reservation.status == "accepted" && reservation.checkout < Date.today
  end
end
