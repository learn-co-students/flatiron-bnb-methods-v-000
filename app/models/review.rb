class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true

  validate :must_have_stayed


    private

    def must_have_stayed
      if !( !!self.reservation && self.reservation.status == "accepted" && Date.today > self.reservation.checkout )
        errors.add(:user_id, "You must complete a reservation to leave a review.")
      end
    end


end
