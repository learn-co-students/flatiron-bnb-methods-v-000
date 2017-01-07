class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :res_complete

  private

  def res_complete
    if !reservation || reservation.status != 'accepted' || reservation.checkout > Date.today
  		errors.add(:res_complete, "You can't leave a review yet")
  	end
  end

end
