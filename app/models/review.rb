class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, :reservation, presence: true
  validate :review

 def review
   unless reservation && reservation.status == "accepted" && reservation.checkout < Date.today
     errors.add(:reservation, "Must have a valid reservation")
   end
 end
end
