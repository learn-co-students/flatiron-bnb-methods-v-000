class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation

  validate :checked_out, :has_been_accepted

  private

  def checked_out
    if self.reservation && self.reservation.checkout > Date.today
      errors.add(:reservation, "Reservation must be over in order to leave a review.")
    end
  end

  def has_been_accepted
    if self.reservation.try(:status) != 'accepted' # .try is like .send, but a NoMethodError
                                                  # will NOT be raised and nil will be returned 
                                                  # instead, if the receiving object (.reservation)
                                                  # is a nil object or NilClass
      errors.add(:reservation, "Reservation must be accepted in order to leave a review.")
    end
  end

end
