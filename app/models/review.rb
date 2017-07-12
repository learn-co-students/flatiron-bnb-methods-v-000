class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validate :valid_review?


  def valid_review?
    #associated reservation -> review.reservation_id ==  reservation.id -- good 
    #has been accepted -> said reservation.status == "accepted"  -- good 
    #checkout has happened -> ?
 
    unless (self.reservation_id) && (self.reservation.status == "accepted") && 
    (self.reservation.checkout < Date.today) # this must all be true
        errors.add(:review, "Must be checked out to write reviews")
    end
  end


end
