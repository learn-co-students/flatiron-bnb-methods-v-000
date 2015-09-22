class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true

  validate :reservation_exists_and_accepted_hasnt_happened_yet

  private
  #You can't write a review on a reservation that doesn't exist
  def reservation_exists_and_accepted_hasnt_happened_yet
    errors.add(:reservation, "not valid") unless reservation && reservation.status == "accepted" && reservation.checkout < Date.today
  end

end
