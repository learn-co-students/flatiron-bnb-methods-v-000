class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true

  validate :has_valid_reservation
  validate :made_after_checkout


  def has_valid_reservation

    if self.reservation #if there is a reservation but it isn't valid
      errors.add(:review, "can't create if reservation isn't valid") if self.reservation.valid? == false 
    else
      errors.add(:review, "not associated to a reservation")
    end
  end


  def made_after_checkout
    if self.reservation
      if !(Date.today >= self.reservation.checkout)
        errors.add(:review, "can't be made until after checkout")
      end
    end
  end

end
