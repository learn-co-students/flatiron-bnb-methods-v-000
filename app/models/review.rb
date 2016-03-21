class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation

  validate :reservation_complete, if: "!reservation.nil?"

  def reservation_complete
    unless self.reservation.status=="accepted" && Date.today > self.reservation.checkout
      errors.add(:reservation_id, "complete your reservation first.") 
    end
  end


end
