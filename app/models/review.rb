class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, :reservation_id,   presence: true
  validate :reservation_accepted?
  validate :checkout?


  def reservation_accepted?
    if reservation && reservation.status != "accepted"
      errors.add(:reservation, "Error")
    end
  end

  def checkout?
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "errors")
    end
  end
end
