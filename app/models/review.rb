require 'pry'
class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true
  validate :valid_reservation?

  private

  def valid_reservation?
    if !(reservation && reservation.status == "accepted" && reservation.checkout < Date.today)
      errors[:reservation] = "Reservation needs to be accepted and completed to leave a review."
    end
  end

end
