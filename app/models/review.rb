class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :reservation_must_be_accepted_and_checkout_complete

  def reservation_must_be_accepted_and_checkout_complete
    unless reservation && reservation.status == "accepted" && reservation.checkout < Time.new
      errors.add(:reservation, "must be accepted and checkout complete")
    end
  end
end
