class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :reviewable


    private


    def reviewable
      if !reservation || reservation.status != "accepted" || reservation.checkout > Date.today
        errors.add(:reveiw, "You cannot review until reservation and checkout is complete")
      end
    end

# is invalid without an associated reservation, 
# has been accepted, and checkout has happened

end
