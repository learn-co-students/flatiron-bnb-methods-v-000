class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, class_name: 'User'

  validates :rating, :description, presence: true
  validate :valid_review

  private

  def valid_review
    #if self.reservation && self.reservation.checkout >= (Date.today)
      #errors.add(:reservation, "Review is invalid without an associated reservation.")


    #elsif self.reservation.status != "accepted"
      #errors.add(:reservation, "Not a valid review.")
    #end
    if !self.reservation || self.reservation.status != "accepted" || self.reservation.checkout > Date.today
      errors.add(:reservation, "Invalid Review")
    end
  end
end
