class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  validate :res_okay
  validate :user_has_left?

  def user_has_left?
    if reservation && reservation.checked_out?
      errors.add(:review, "You must have checked out before you can leave a review.")
    end
  end

  def res_okay
    if !(reservation && reservation.status == 'accepted')
      errors.add(:reservation, "Sorry, your reservation hasn't been accepted yet.")
    end
  end


end
