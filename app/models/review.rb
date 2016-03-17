class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  
  validates :rating, presence: true
  validates :description, presence: true
  validate :legit_review

  def legit_review
    unless self.reservation && (self.reservation.checkout < Date.today) && (self.reservation.status == "accepted")
      errors.add(:legit_review, "This looks fake")
    end
  end



end
