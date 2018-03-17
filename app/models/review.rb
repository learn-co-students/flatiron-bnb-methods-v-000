class Review < ActiveRecord::Base
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :legit_review?
  #before_create :show

  
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  has_many :listings, through: :reservations

  def legit_review?
    if self.reservation
      if self.reservation.checkout > Date.today || self.reservation.status != "accepted" 
        errors.add(:reservation_id, "Reservation checkout must be in past")
      end
    end
  end
end

# Official solution
# class Review < ActiveRecord::Base
#   belongs_to :reservation
#   belongs_to :guest, :class_name => "User"

#   validates :description, presence: true
#   validates :rating, presence: true, numericality: {
#               greater_than_or_equal_to: 0,
#               less_than_or_equal_to: 5,
#               only_integer: true
#             }
#   validates :reservation, presence: true

#   validate :checked_out
#   validate :reservation_accepted

#   private

#   def checked_out
#     if reservation && reservation.check_out > Date.today
#       errors.add(:reservation, "Reservation must have ended to leave a review.")
#     end
#   end

#   def reservation_accepted
#     if reservation.try(:status) != 'accepted'
#       errors.add(:reservation, "Reservation must be accepted to leave a review.")
#     end
#   end
# end