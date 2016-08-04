class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :res_passed
  validate :res_accepted


  private

  def res_accepted
    errors.add(:review, "reservation must be approved") if reservation && reservation.status && reservation.status != "accepted"
  end

  def res_passed
    errors.add(:review, "must check out before you can reivew reservation") if reservation && reservation.checkout && reservation.checkout > Date.today
  end
end
