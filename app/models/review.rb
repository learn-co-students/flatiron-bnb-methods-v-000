class Review < ActiveRecord::Base
  
  validates :rating, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validate :invalid_review 

  #need to add validation:
  #is invalid without an associated reservation, has been accepted, and checkout has happened

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  def invalid_review
    if !(self.reservation && reservation.status == "accepted" && reservation.checkout < Date.today)
      errors.add(:inv, "Invalid review")
    end
  end

end #ends class
