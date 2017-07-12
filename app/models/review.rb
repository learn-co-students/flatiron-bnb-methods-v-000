class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: :true
  validates :description, presence: :true
  validates :reservation, presence: :true

  validate :checked_out
  validate :reso_accepted

  private

  def checked_out
    # binding.pry
    if reservation && Date.today < reservation.checkout
      errors.add(:reservation, "You must be checkout out to leave a review.")
    end
  end

  def reso_accepted
    if !reservation || reservation.status != "accepted"
      errors.add(:reservation, "Your reservation must be accepted to leave a review.")
    end
  end
end
