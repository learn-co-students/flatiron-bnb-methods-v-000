class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :associated_reservation, :checkout_happend

  private

  def checkout_happend
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "sorry, checkout hasn't happened.")
    end
  end

  def associated_reservation
    if self.reservation_id ==  nil
      errors.add(:reservation_id, "Has to be associated with reservation")
    end
  end
end
