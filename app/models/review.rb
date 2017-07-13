class Review < ActiveRecord::Base
  validates :rating, presence: true
  validates :description, presence: true
  validate :res_assoc_accept_and_checkout?
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  def res_assoc_accept_and_checkout?
    if self.reservation && self.reservation.status == "accepted" && self.reservation.checkout < Date.today
    else
      errors.add(:reservation, "invalid without attributed/accepted reservation and past checkout")
    end
  end

end
