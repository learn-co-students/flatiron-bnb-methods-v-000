class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :checked_out
  validate :status

  def checked_out
       if reservation && Date.today < reservation.checkout
         errors.add(:reservation, "You can only leave a review after you checkout")
       end
  end

  def status
    if reservation.try(:status) != "accepted"
      errors.add(:reservation, "You can only leave a review after your reservation is accepted")
    end
  end

end
