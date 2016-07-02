class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :valid_reservation?
  validate :checkout_out_yet?
  
  def valid_reservation?
    unless reservation && reservation.status == "accepted"
      errors.add(:guest_id, "Something went wrong with your reservation")
    end
  end
  
  def checkout_out_yet?
    unless reservation && reservation.checkout <= Date.today
      errors.add(:guest_id, "You need to check out before you can add a review!")
    end
  end
end
